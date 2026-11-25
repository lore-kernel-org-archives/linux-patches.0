Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619823;
	b=FXYMI6x9g60rSumuqJH6P/vk2uFoE8ekauK626x0q9NvKhLKzy04sDLGa/FKMSTkWDTn
	 PE8/Uo3DFmNwsIAJapY8wcClSKMKAa+17l/JWrk1Aupt0KmxYtvtBn0i/jZbcEcl04yoT
	 pOTOe32u8Xh8AF35RecjcpEsi1nUNptYCTLfdfSZb0bIbmJMMWkUv8iB0u/FxgFuKCyT+
	 oXp6e3SIfJdKg2btwXn8mABwOBNYzkMp9VA/ZF7da56pQWgXLtvUXb2Un17aj3Z8qhAiU
	 Fxxp7kDOcXE0CON5xWLH3gbvmIxo4hLUC3nwlAd/yI1PGzVECUQxSPXFi4ChpLLqS3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rDrFxN+4xRs/OnaiIdOpAOkNw24I6TAOU2tVTsJJr2M=;
	b=e545Bk6Ze5z0eQypPNfF6PGLWggKMn9eQtwPkJaBK4rO3AUDSW/6Ms+DOPUi9Fkf+nc3
	 x9aa0nYn6cNLcR1B3H+wfNkZudgL1jmG1q14AqInyvIPChdxCKkH6Aspg+GNgveYohjnI
	 GWaeFmSjho4YHclEqMSKCV+49jmr+wz4sdkVSUq3GCQ3mzeTx/FDN5/toP2H4YNNQyCaI
	 jbfFpZfr2fPbTW0EPnNPqE1mg5m4nr7Ayg8z/h2TPoAAwwqn7Lwv0avHGLc7sSPEPD3+z
	 yfe7uFECGsbLzWoOGKXTZVS72YEoiP5vjwQXz6645A5lAij9Z4TIiEk/3d77mqw7Qmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZAZE4Fm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CACD606A329;
	Wed, 25 Nov 2026 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZAZE4Fm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01911F000E0;
	Wed, 25 Nov 2026 15:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619823;
	bh=rDrFxN+4xRs/OnaiIdOpAOkNw24I6TAOU2tVTsJJr2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xZAZE4Fm8l5UH3OBf7I73PjfN4XsXiJ3DVD1zpoba+Uk1RCqsEEchn9RFLNm8oIPw
	 RGJ6yVtPFu9c+2iCqepgEZn+kP53sSEZq6MUhRveNfW9CT0XHEm1pAMOhbdNoi4Ni1
	 eAzn8x03Sq4/eBS05/QhK9AYJfa1lIZvgy6QK2ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 7.3 0719/1005] cpufreq: Cache post-resolution target frequency in __resolve_freq()
Date: Wed, 25 Nov 2026 15:34:17 +0100
Message-ID: <20261125143838.600456311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 166207cac45191637c47a457a5c16ca6b6773a16 upstream.

get_next_freq() in the schedutil governor returns the resolved
frequency from cpufreq_driver_resolve_freq(), and that resolved value
is then passed to cpufreq_driver_fast_switch().  The only reader of
cached_target_freq, acpi_cpufreq_fast_switch(), compares it with the
post-resolution target frequency, but it holds the pre-resolution
clamped frequency, so any request that falls between table entries
misses the cache and falls back to a table scan.

Address this by making __resolve_freq() store the post-resolution
frequency in cached_target_freq.

Fixes: e3c062360870 ("cpufreq: add cpufreq_driver_resolve_freq()")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/14161745.uLZWGnKmhe@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -488,8 +488,8 @@ static unsigned int __resolve_freq(struc
 
 	idx = cpufreq_frequency_table_target(policy, target_freq, min, max, relation);
 	policy->cached_resolved_idx = idx;
-	policy->cached_target_freq = target_freq;
-	return policy->freq_table[idx].frequency;
+	policy->cached_target_freq = policy->freq_table[idx].frequency;
+	return policy->cached_target_freq;
 }
 
 /**



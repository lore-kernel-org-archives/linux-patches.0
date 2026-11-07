Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064685;
	b=AUkfR/rViJyjuDGL5KStdzP89vppbYnSZ1KZXOY77VakDkB3JxmOVX0XFKBTG9R3xHsR
	 JRLnWctS+BKYU6a3/dql4tBBAN8CU0OeYhffhYkhwVN0xdyD6psk08aKnp3uwDyMU/tFm
	 PtlB3kb9Iy8hwT5a1AO30J+BMQOluUYO3TKoYrb13a3hLJ4T5WsoNaK8qxbTYVa5G6UKq
	 z0dL7p2AAWK1hTzj0EXJQ6PLkcNazASdNM6ppsmtJryT4OZ14d6UjRhiGrJYgPKrbx8uZ
	 9Jkomb9vcNKWSwsXi9Rsb/F50DW3llyU9MnCi267IT1g3etrHSAvYZaxnZUuHquV2sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZHVmF0XMOXLzinmCjPp/nM6A1Ep0etQEKIXcizwnlWM=;
	b=VLhL51CA+7Y5JlsQYgmACSQhwOgQunaG+u70HaWPqYOaub1beBfoT41Ldtlarcs5oKRW
	 I9dkmQV/7nUSk3Gq9n9YTC4A3aW82d4iV95jyTADfJGQaiyaH6BC6+m8UtWqlO2YDlj/h
	 JBioMjLtYByaRDs30JHsZVhNHD/F5RssONJAJvTAKGpd4eD+T8achfIa4jaaUz+dNPe5/
	 U3whfOrp/BxamW5gTJtvUG8Hn5Jw+Spd1GSj7jLOgQVVavTYsHKbugxe3+JmcsnTqQqdo
	 WqtamZS0e7RG+qqw4NXxFpjgeHlBMj0XUa5FSrEKqIiPoSSNOAXOMkfL2PAq4CQfC5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tFhicV8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F13606B8A5;
	Sat,  7 Nov 2026 15:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tFhicV8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FBB1F0089F;
	Sat,  7 Nov 2026 15:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064684;
	bh=ZHVmF0XMOXLzinmCjPp/nM6A1Ep0etQEKIXcizwnlWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFhicV8rrQycFc70pdHnel1od5yG5mdsdZppP4T4rM+i0WJvK3mlxotAXw3id2/tn
	 hljFNqH2Bpsk3BZs8TL8xFEVtNvv/dSGSSx1cZKUd1wKF+cbb72LsGNmtD64CXoIjU
	 M7T71y0NPDLtQdUfvIOc1VxyDEdGikm7CBzhhcPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijia Wang <wangyijia.yeah@bytedance.com>,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0679/1257] platform/x86/intel-uncore-freq: Continue restoring limits on resume
Date: Sat,  7 Nov 2026 08:49:35 -0500
Message-ID: <20261107134958.018215920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixiong Wei <weiguixiong@bytedance.com>

[ Upstream commit 38998529f45c02edcf96b0a3ddd3c83de6d11bbe ]

The PM notifier iterates over every uncore frequency instance to restore
user-configured MSR_UNCORE_RATIO_LIMIT values after resume. Entries that
have never been configured legitimately have stored_uncore_data set to
zero.

The refactoring that split common and enumeration code changed the
iteration from active control CPUs to all allocated instances. It also
changed the skip for an invalid or unconfigured entry from continue to
return, causing that entry to terminate the entire restore operation.

On a multi-package or multi-die system, configuring only a later instance
therefore leaves its limit unrestored after suspend, hibernation, or
restore if an earlier entry is invalid or unconfigured.

Use continue to skip only the current entry and restore all remaining
configured instances.

Fixes: dbce412a7733 ("platform/x86/intel-uncore-freq: Split common and enumeration part")
Cc: stable@vger.kernel.org
Tested-by: Yijia Wang <wangyijia.yeah@bytedance.com>
Signed-off-by: Guixiong Wei <weiguixiong@bytedance.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260929163133.14326-2-weiguixiong@bytedance.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
index 667f2c8b9594a..c44e7e38cae25 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -211,7 +211,7 @@ static int uncore_pm_notify(struct notifier_block *nb, unsigned long mode,
 			struct uncore_data *data = &uncore_instances[i];
 
 			if (!data || !data->valid || !data->stored_uncore_data)
-				return 0;
+				continue;
 
 			wrmsrq_on_cpu(data->control_cpu, MSR_UNCORE_RATIO_LIMIT,
 				      data->stored_uncore_data);
-- 
2.53.0




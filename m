Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062520;
	b=KMad5sO9gu/BfEu5rfe8syQiGek05L+D32Jx88uZLotskw/Eg7dn25Vt36UAlzcGy33h
	 hYNsOJvE4EIj7F7cigBfCCWure6Rfdz+tjf3W/jPI1Bq/HucdYmeZheomjNEyQumD+mH0
	 SheroAxeCbmZLcEm9wuVKXngMOAcsCL+fX2EhovzaXyjzplQpV4z8ppPPH6DUgkK2v8SK
	 f77J88DWH5E7LDU6IwdccjLYHGu8s1MXChz/RN5wZG88yK+sFyf2ob6W4GssAbj+c7pey
	 Djtfmp+e3qj3RHBdP8JTB4yO33RlW33WliLeGQqET8EkQFJhCaAC4X5LwivCkwIObBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QAzsBqKtjsvYQdx5FEj0yQUBRHpGIx1x3SVCdOsAwV4=;
	b=MrQSVglvYnqNXYrQrpL+IJVA2al1lfQBEX/5b/dtkqAEN9K/aSENp9LDSIm0w8OYg33J
	 5zm+lSb0PavwSb6C/Fn+EZFCv1mdVJwZW17b1klLyeETYvjZvkjkge0ysxcUNvlBPasaM
	 iUayig9oGpuLIxzvJVXA2vj1Q0jyR4ph+UBbq6vH3gplFXZAFDBMbjkXPtw7ITVHqYRgD
	 hkXLpDSKLLLj7eNs27Sy26fgUINBSl9wXhrtHCWU8wca3WLnS/4NUhYZ0zF1Icu9eib4+
	 nDBLjEUew2J0T19IN2iZHIMM6G0TkyckM2seAJD6CX/X8LYFUs6EjcaX29C3anxQ9dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MikYVVFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A376D608360C;
	Sat,  7 Nov 2026 14:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MikYVVFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278971F008A4;
	Sat,  7 Nov 2026 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062520;
	bh=QAzsBqKtjsvYQdx5FEj0yQUBRHpGIx1x3SVCdOsAwV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MikYVVFlYDVr+Ky/oJh4MGuvNe2C/WSd5fS9ONMcBbdGbZBWQTe1qYrKo3vKl1mIt
	 1SNINFe+i5WbVqE+Dg02aI+9SQkqh8bgi9kFJo30ktw62l2B+ORKcpn2fmc85ig371
	 pDOm/NEiD1OV2GJcKGbSb+5gCQmH7lKg6pNt7PUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1415/1536] cpufreq: intel_pstate: cancel HWP notify work in driver cleanup
Date: Sat,  7 Nov 2026 08:57:11 -0500
Message-ID: <20261107135037.569605339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 0ffc7534a210105ba973167a5b86d5ab39d4031f ]

intel_pstate_driver_cleanup() frees per-CPU data without cancelling the
pending HWP notify delayed work. If hwp_notify_work is still scheduled
or running when the struct is freed, the work function accesses freed
memory via container_of().

Call intel_pstate_disable_hwp_interrupt() before kfree() to disable
the interrupt source and cancel the pending work, matching the pattern
used in intel_pstate_suspend() and intel_pstate_hwp_offline().

Fixes: d845cd901b28 ("cpufreq: intel_pstate: Support highest performance change interrupt")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
[ rjw: Fixed the Fixes: tag ]
Link: https://patch.msgid.link/20261019222635.1741146-1-tristmd@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index f1910f9109f01..8cb10f99a84be 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -3368,6 +3368,8 @@ static void intel_pstate_driver_cleanup(void)
 			if (intel_pstate_driver == &intel_pstate)
 				intel_pstate_clear_update_util_hook(cpu);
 
+			intel_pstate_disable_hwp_interrupt(all_cpu_data[cpu]);
+
 			kfree(all_cpu_data[cpu]);
 			WRITE_ONCE(all_cpu_data[cpu], NULL);
 		}
-- 
2.53.0




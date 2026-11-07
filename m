Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062923;
	b=p1eBluvMPDmlZ1on4dZVduBY9vVe4r460aG0+OW/lR6gx8t8n8UEWSkUy657dHtMo0CC
	 yQ35nj5pGNiKtB+OvG0ijzqniEMYmUCoqHzbRbH6cyi6igqN4CxEEZLfJ9j7L8vUEJGJ4
	 NdAVTZKX25uYPfCoa+FcURMcN4aselz4bV5yCS9x291kTLTx/qVDTy8k+bSSslgn6ZTgk
	 LEcxhfj5YE7ESOWM40gH16r5FdIYiB4WuGhlnzVFhtOxyEwEUCfWWdR2x66hZ17a7CEoQ
	 yhey2PrJfIX0m7wh9cKbfrzMYoAQkTN71kvreUUKav7h+fVdK6Kanojvn/D93BifCGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tDSrF0NfXFW7IKGXCLcgRHKLLxpTaBDnt6KTc7S5nx4=;
	b=k7dYtXUBOKVrpfG6aml7UurVxMyvY1RY56mo6B41rteWLC6ozhicl5fu0xaWMJOStJCf
	 Oe2VmTxZFdFlZB3+T2MQ/YmCl/rvh8VSQoC16bO/2a+TLU/3RNT+diYCS2BFZdXjTNErS
	 wcnDH0fxZjh0QnUrzOWCRN603EB5B4cmQ+3GnnV/L1OzjK+i/u2kzFo10Hc3dr+WksanW
	 JCLCCv5zCq3JhhXDFWqNLchO5mmR+brYqtH3YUnGp9lL2Z/SqYargAJMrv283C9stwGqP
	 yMtDG05FFG25eiuCPEG+aDaI8q7SqQ5NIDapQvGUtPJ9BFukRJLoojSmWXIweNY74iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGJBG6F6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7734D606A326;
	Sat,  7 Nov 2026 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGJBG6F6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226151F0089F;
	Sat,  7 Nov 2026 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062923;
	bh=tDSrF0NfXFW7IKGXCLcgRHKLLxpTaBDnt6KTc7S5nx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGJBG6F6LZanRqK3DTJxN6A6OAmmmgJMkwKy6SmGs73gh5iPhC92Zxwg763fihFdH
	 HrT79QQNuo3eFkQHp0Ip8jlQo6DMt8oMsEwgdEw/z7sIBjDpexjqVz6KdumXsiuz4N
	 GnZEt1oidaV3pXSXQeV6gAlBJA8admz+h0//6BJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	LFRon <ronforever@outlook.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 197/869] cpufreq/amd-pstate: Skip auto_sel write when it already matches the mode
Date: Sat,  7 Nov 2026 08:47:59 -0500
Message-ID: <20261107134858.726869635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit b400642c5e93863ec17ea15fcbd3efc81c299531 ]

Since commit 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active
mode on shared memory systems"), shmem_init_perf() programs
AUTONOMOUS_SELECTION_ENABLE unconditionally, including in active mode.

Platforms that exclusively support autonomous selection report this field
as an Integer of 1, as required by the ACPI specification, instead of as a
register descriptor.  cppc_get_reg_val() reads such a field back
successfully, but cppc_set_reg_val() rejects the write with -EOPNOTSUPP
because the entry is not an ACPI_TYPE_BUFFER.

shmem_init_perf() propagates that error, so every amd_pstate_epp_cpu_init()
fails, cpufreq_register_driver() ends up with an empty policy list and
returns -ENODEV, and amd-pstate refuses to load at all:

  amd_pstate: failed to set auto_sel, ret: -95
  amd_pstate: Failed to initialize CPU 0: -95
  ...
  amd_pstate: failed to register with return -19

Skip the write when the register already holds the value the requested mode
needs.  Active and guided mode are fixed on these platforms, which report
auto_sel as 1, while passive mode still fails to load on a platform that
cannot disable autonomous selection, exactly as it did before the
offending commit.

Fixes: 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems")
Cc: stable@vger.kernel.org
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: LFRon <ronforever@outlook.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Link: https://lore.kernel.org/r/20260918090909.86544-1-guanwentao@uniontech.com
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index b1a200531628f..0b06bbd7215ff 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -469,8 +469,10 @@ static int shmem_init_perf(struct amd_cpudata *cpudata)
 		return 0;
 	}
 
-	ret = cppc_set_auto_sel(cpudata->cpu,
-			(cppc_state == AMD_PSTATE_PASSIVE) ? 0 : 1);
+	if ((cppc_state != AMD_PSTATE_PASSIVE) == auto_sel)
+		return 0;
+
+	ret = cppc_set_auto_sel(cpudata->cpu, !auto_sel);
 
 	if (ret)
 		pr_warn("failed to set auto_sel, ret: %d\n", ret);
-- 
2.53.0




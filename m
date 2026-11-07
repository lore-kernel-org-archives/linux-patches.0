Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063588;
	b=iBEQbkgFmYbgJcIQ8ne1rgg4cabBEeM0nGO/2mJstszPsQAy9gzaKy7R9Rp2a58NJDwn
	 JxuwODomBh/dG8SRnz6ZNkBlZcmNtZDwMl/L9nM/4JDFS3/HafrMXpcmZUqziCxypWGr1
	 fsgDtr5/2racZyW16hFPkvDx/ZVLXLKwBC4g4TSro71LtbbwoagjRJTE1/NnmDRwCarll
	 T4dk94sjFvb1xGLXkad8nufar3+MJXX7jHtAse9QMplQRjO1APlqbK7zT6XWKSzqrXo8K
	 h2N1VcZlOKbRZ27MRGkEqZpQitFSJ45qoqwNpWUjxUW1dzVYuHk22Hn1sujX2YJVFhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tELK7XS11lZaBtUJTa7EFoNZ4kQVCl21/gAbR4mjEUY=;
	b=V9gxvlpLfkjQu2CvHmgEN+fKj/hJqScUf5EspB3DV0B+PmPJ//2ERHdGqXtzZWmYzNEk
	 MLD5WhJF0YJ0WwBFTmVP84G16GtclusHqf6XGOZIdUtF3Ves4pAek5MaydBCbaR7wOt5l
	 Sb0/92MdUWiocHH09mEVT7t5AA2IF6kKwfwqmmaGzbxAXsYHoGm0CWQiJFDSc8lj+B/aT
	 FgknFs1AuGG+HbjK8MgL02xeQPNW8O3EK5vRVugO/zPZ9MB4wj4fO73r7zcCD39m3DqEd
	 Ai+KicVGCZGY7Jrq0o2acMDLUVTuKfM0z9gDZclgDHIixcdQdztlMA/D9YnPAKq0qqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ed/5pffN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB72060A263F;
	Sat,  7 Nov 2026 14:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ed/5pffN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A05D1F008A7;
	Sat,  7 Nov 2026 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063587;
	bh=tELK7XS11lZaBtUJTa7EFoNZ4kQVCl21/gAbR4mjEUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ed/5pffNvuSpk4RsOF2UyF4BJJy3Po4RgqvWDbRjDP0/s56VwjMAsn86W8zVhsFj9
	 GkDWJoyQL1ZkhLYssUYrCmqczyquBJf3a+7sdZ/LR3ZJeOeBmg2HAOmIrSI9yklhjH
	 wOuTUBfYqUVQIAEHQqdU3RC4+bF5QI8h6A4xXwnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 714/869] cpufreq: intel_pstate: cancel HWP notify work in driver cleanup
Date: Sat,  7 Nov 2026 08:56:36 -0500
Message-ID: <20261107134917.076953280@linuxfoundation.org>
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
index 1de12358c0b98..a498d66883b52 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -3458,6 +3458,8 @@ static void intel_pstate_driver_cleanup(void)
 			if (intel_pstate_driver == &intel_pstate)
 				intel_pstate_clear_update_util_hook(cpu);
 
+			intel_pstate_disable_hwp_interrupt(all_cpu_data[cpu]);
+
 			kfree(all_cpu_data[cpu]);
 			WRITE_ONCE(all_cpu_data[cpu], NULL);
 		}
-- 
2.53.0




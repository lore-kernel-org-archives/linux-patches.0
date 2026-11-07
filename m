Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065257;
	b=2ZX/FlP8HFbHwvReDu0c0Ogk3CjRg7GccoDV4Sr6FAUWdAqE0nHvh9UqA53Ze4haY5WQ
	 cgQ3YVMRltpUaqNxwkZywFJh0VWpAO96FbeQ2XM7fW+8SmQ6Q5iDxjMpfS6OIVU4xiBch
	 zwVDxw5fUg+SMQr/qL8HHkiWRRQj1Fbmxr7LCUKxjxWxhcfLCcbyizHMdfi9oZuNKGRIe
	 mIhrH1zybjT6MwHMYHlDV44HfurOrhXOjYJAF/PO/YIXdq4LPyaowgeQe6pn6sWRj6YdD
	 8SMFmBCSkIL6Kn7ZKUBJZiI0Hjodc6lehkNMwUC3VI5IWbNERRRS4lIlC1U3cNrix9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T3NtAXwUMUeb7j9VQYhdVJ5OHqfHQc/S8HKdwykQj0w=;
	b=qsGSdpkmt376A9/0OBsM2vJsAasLSDnwi155A5HJzcfNjHWfViZr0CIb3Rvb+3qzAWRv
	 IOiq2egrdyODW44bahYQUbgYCVi6bUuOVTChW34YYZi2rk/5WE76ONLmHiKYuGPrdrx2W
	 O4SWGkRQOE8nOagqmdnr+AjjXvAmmgqfO1q2hRw7kjlefNaBkiDn9WZBvf4Llxhtq7diu
	 eyFzUMNtnsHGa2AB/bfuQWtyznoQ2GvBjlLOJo6hXWpMskM3LlI06266x/jqJYOp+lc+Y
	 WQzfWUA8ckX2n8IAEZ/QQ1cEMdiTKBVAaBdhG7txEmkpgntiJr2XG2X1kiQ0/4EXP1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMAp6ime;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B931606A32C;
	Sat,  7 Nov 2026 15:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMAp6ime
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E712B1F0089F;
	Sat,  7 Nov 2026 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065256;
	bh=T3NtAXwUMUeb7j9VQYhdVJ5OHqfHQc/S8HKdwykQj0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMAp6imedRLBAQ/klcaY/vzz28tDCbkUjX/8pUBqDHg87m04+3WyTiBrB6CKHcXd3
	 7zCmG0yC7Z7TTWkjlEOSnvlqp1z1s9XbSNPx7TodjhFjZzrGbxogHsOEvxJCxCTHxN
	 xQCXOmAMoDq8j9e3Pvq0D5BrHnValIHDQ+j0rQTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1025/1257] cpufreq: intel_pstate: cancel HWP notify work in driver cleanup
Date: Sat,  7 Nov 2026 08:55:21 -0500
Message-ID: <20261107135007.634760529@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 17158cb25dd89..0e6ae4cdda5de 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -3436,6 +3436,8 @@ static void intel_pstate_driver_cleanup(void)
 			if (intel_pstate_driver == &intel_pstate)
 				intel_pstate_clear_update_util_hook(cpu);
 
+			intel_pstate_disable_hwp_interrupt(all_cpu_data[cpu]);
+
 			kfree(all_cpu_data[cpu]);
 			WRITE_ONCE(all_cpu_data[cpu], NULL);
 		}
-- 
2.53.0




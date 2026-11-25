Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626352;
	b=xRth6HFA2UGDwoUQ5KRUE7+/5T7Q19OsXrr8TawUqClP72FGV4rUBqoxpFpwKgERoQkn
	 rxaycazM/YOmV6AN27kyAu6HviEx+MkSiPB5e+EiRzqoJTgy1/8E2mkxBbXkYq4p87J2l
	 uBcEI0DJNBD8fFwkeNQqiMhvu6Yl750AauJ/kUW3vtnjn9AOdNVEnUW4G+E5BSa4v3Vj8
	 8unP9NpKiss4+lb0tk9IkYGpygTKPwipo24RHVlxUuLF10X4dwYrQKKCu0r/8PiSeggCp
	 bZleg18PofC3rtcloiqQKNtR3dS2+JnC0jaAkqUMhXtbNxvLi6XAJv85Bo7XM+6Ivtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1OmGxcvbs51zL/m7TrFl1cfcUtDJQqpHY6kifo9sT1k=;
	b=0k4uWI65MgDRNys//vOeNMtIopNjQKbwvNaa2s4OthnszP/r1q0ZogH7F0yjy2w2tzH6
	 8sOxMUDa8z/rNS5BdXN4y+p5taCZBjbiY0LLOjesNJH7C7jLGd4XlxWlaVT7E/TsDacVz
	 2Jx7NUIi+xouuFDSd/gSnDCW7QzqSlpXrkW0DEVnzec/YHT57d/DCWKAG/MGiQIqKC1Zv
	 8PqzBg901XzMrHHN3MowSm7a486YMKPM8F0p25fB/tpvIRMoSKPqAPc6l6xYJIOtLNipB
	 JHyykNHPX82y1wm08SKe+Nr4A/1OiT8O9++xmwOX5R/XqID/6tyH5asjaVSJMDKbBbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHrkoCA4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B601C606A321;
	Wed, 25 Nov 2026 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHrkoCA4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44DA1F000C6;
	Wed, 25 Nov 2026 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626352;
	bh=1OmGxcvbs51zL/m7TrFl1cfcUtDJQqpHY6kifo9sT1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHrkoCA4ekpvBgFZWx15GC9cKDnmteKHZQ1qnaGV2wU/4bfZO/tUAmgR7udK5twM7
	 +6MD4stHFbuUPgb1lVrOUPI6yPB4JNVpwcptTewU7M/EiUpOGvqJQ9MHY9Oz5mAy0+
	 aKhYB70EmobVhw8iGLLLWrr1mcuPCJTbTjVF+Kwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 816/816] cpufreq: Preserve global boost state on failed updates
Date: Wed, 25 Nov 2026 15:39:24 +0100
Message-ID: <20261125143908.058089960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

commit a0cde2b601bc32b76d61e50141c619790e5e2e41 upstream.

cpufreq_boost_trigger_state() restores the opposite of the requested
state when updating policy boost state fails. For example, a failed
write of 0 when global boost is already disabled enables the global
flag without enabling any policies.

Save the original global boost state and restore it on failure.

Fixes: 121baab7b88e ("cpufreq: Force sync policy boost with global boost on sysfs update")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20261105215223.1263415-2-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2825,6 +2825,7 @@ static int cpufreq_boost_trigger_state(i
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
+	bool boost_enabled;
 	int ret = 0;
 
 	guard(mutex)(&cpufreq_boost_mutex);
@@ -2835,6 +2836,7 @@ static int cpufreq_boost_trigger_state(i
 	 */
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	boost_enabled = cpufreq_driver->boost_enabled;
 	cpufreq_driver->boost_enabled = state;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -2855,7 +2857,7 @@ err_reset_state:
 	cpus_read_unlock();
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver->boost_enabled = !state;
+	cpufreq_driver->boost_enabled = boost_enabled;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	pr_err("%s: Cannot %s BOOST\n",



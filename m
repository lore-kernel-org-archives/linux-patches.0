Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35E544AB6E;
	Tue, 21 Jul 2026 21:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670761; cv=none; b=HpMxqJz5TAb/0huKaHr0DePo565dRXk+8TtUxgk7bs27ogyYZw2ppeQId6wvOVcD5HN1d+i39sLxvlYJaz64JXcuNb90a70haix8CXEJZxovehsR689nSuai0vsndENlLm3e3+sm7/MYwXbNw2WFFMp4XrlzSco3NiY/Q1WmhpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670761; c=relaxed/simple;
	bh=5XR6AO+xW6bJOWez385oZuBzDQzWTs4pgwMpucllyCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3b5vSQIoHwTf00yGktDZfHqAB3HDZfjio3yPWXcZSgIAbyBE4f2Wjf6rnYvRgbsGHs6uJcgJ44+nQnNv87aQRTozD9NExQKuTTQOSN2LZQoYvgZbvM0yya1NpTnRLkxZqyqIfzMEXemBJiUsV2dphXnXcqNIoXZFgHJ9o+PRSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1YeGaw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1YeGaw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647BB1F000E9;
	Tue, 21 Jul 2026 21:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670759;
	bh=KAhaJMNS+gsK/oZ9GhrkQPmyJi+Tl5Pe0fYzmbgIXyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1YeGaw5HAek/rMmdnRcpPXgtD2nINfMqu0pwBic2TNG5Gn4CdomcC0i6vh3umjDU
	 AO7Y23en+1uyvj90s7uSWG1FkegboOqxvswmDjoiJ0mvBadzruRwmVVoC5SOohp3hD
	 2/YRUkCfPhm3alzF84VdHHFsLWAU4xw+TLu9QF1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 1053/1067] jiffies: Cast to unsigned long in secs_to_jiffies() conversion
Date: Tue, 21 Jul 2026 17:27:34 +0200
Message-ID: <20260721152448.143518540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Easwar Hariharan <eahariha@linux.microsoft.com>

commit bb2784d9ab49587ba4fbff37a319fff2924db289 upstream.

While converting users of msecs_to_jiffies(), lkp reported that some range
checks would always be true because of the mismatch between the implied int
value of secs_to_jiffies() vs the unsigned long return value of the
msecs_to_jiffies() calls it was replacing.

Fix this by casting the secs_to_jiffies() input value to unsigned long.

Fixes: b35108a51cf7ba ("jiffies: Define secs_to_jiffies()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250130192701.99626-1-eahariha@linux.microsoft.com
Closes: https://lore.kernel.org/oe-kbuild-all/202501301334.NB6NszQR-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/jiffies.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -382,7 +382,7 @@ static __always_inline unsigned long mse
  *
  * Return: jiffies value
  */
-#define secs_to_jiffies(_secs) ((_secs) * HZ)
+#define secs_to_jiffies(_secs) (unsigned long)((_secs) * HZ)
 
 extern unsigned long __usecs_to_jiffies(const unsigned int u);
 #if !(USEC_PER_SEC % HZ)



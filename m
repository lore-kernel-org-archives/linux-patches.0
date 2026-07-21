Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4873BA232;
	Tue, 21 Jul 2026 21:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667976; cv=none; b=O8a3yDDrr3Q9KhxHfC6gTyPknUAs0YJQzS/U4qaWf0qMjwTWd3z2F84wY+9wkY3L+7b8tlD6PJeppQ7mzzTCO3dO54b2xcbfpSkjFF47X5K1Gdu3e6V0Ulz719JFnbCyhnj85DnIvs1nTmb0rf4mUVDVM6UBSCMQ0lganIc4NkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667976; c=relaxed/simple;
	bh=qhhJRBS2lVl+5ZvlTo/ATjKCoCdrJkyHfjmjFsG+3bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YH9UNJyGbx9S6NFjrxwIMwyzhULaXwmAUxCtTOlMmhODBFRIXFHiUTIt8WUgJT3wzoVNDfQehZtWgSRNrIS1YxIyvHsHkd0F21c7Y9iDuOKEvXqvypmyJ2SELIfCBSfSbsBBh9fiowKfkYkHIumEQfDYYpkxmGdoRJIgG9Izsxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHnSzszc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHnSzszc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A4C1F000E9;
	Tue, 21 Jul 2026 21:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667975;
	bh=nD5Sbv+T2Rz4DTaDfFJZEuC8bwE1MXd8dJ/drguXSoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHnSzszcurQcwuAdx164I5A11mJ69xUFx2gTVZZCXbPIZ66BOX9WdjIElucdoIYVu
	 zeK+iWBoGSDuLCjZwalxa+tIkcsPWSc2t6krhpBG33XehCKBNxb1Ds5UeV41rTGBFn
	 fiF9Q9wOR/VGo//WgYIf1RQ+qCSeluGX5S1sJVOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 1264/1266] jiffies: Cast to unsigned long in secs_to_jiffies() conversion
Date: Tue, 21 Jul 2026 17:28:21 +0200
Message-ID: <20260721152510.110679371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -534,7 +534,7 @@ static __always_inline unsigned long mse
  *
  * Return: jiffies value
  */
-#define secs_to_jiffies(_secs) ((_secs) * HZ)
+#define secs_to_jiffies(_secs) (unsigned long)((_secs) * HZ)
 
 extern unsigned long __usecs_to_jiffies(const unsigned int u);
 #if !(USEC_PER_SEC % HZ)



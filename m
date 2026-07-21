Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E81D471268;
	Tue, 21 Jul 2026 20:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664584; cv=none; b=sYwzP2bY6GA31oI/2ot/0aMqDDg81iIF6A3xcRrdX18xPBHje9yRAi+b+mHJQzpAJN4WDbQm3+cJF2AEZYMeEBhfQ5YvYjacdTug4nEwGAJ2HY/9bw3cwwcZ0feL0oP9OoCSE20MFJOFqN2h2HA/1/n65ej+94NyVY0kuYm3sF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664584; c=relaxed/simple;
	bh=49x21NpcSJvZURIqdT9UkSLtoFgnR7QXFNDLICFQFT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRPfUcJpVfR3Tyhw1fs6jACW95pJL9A7bf/ydxRddcl3QL8nR62IrXXjF+V0qsss1Q2EMpg+QO5mLotQeeYUkF/NvWX3oBCWBDJailjufl8B+9vuNCFD2cn/dR2c464nekRfJyGrFKSQ2myt6HHPo5L1+WQyvFHJOuUjwQqUDe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4gOnD5e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4gOnD5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04E31F000E9;
	Tue, 21 Jul 2026 20:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664583;
	bh=k8RNVRc7B3z0O5UtQ9rzVdNUxaUmuvUDEei7Uaxiwt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4gOnD5eGAgUMM6zXOIhaKhxeB7FTfhSzSb6lVfNmRIXqy5tdLGrxmzdbI9Ef3RpF
	 0qA+zzkx9maD6Zf6fQhErEfa/aAsoYIE4y2BAYUQpo0Eh440Uc1HUFcUxJC/C+wZ7Y
	 gZkld2JusqdTq1PGfKuYa5mBaNsKgbP/kzw9eFD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 1256/1276] jiffies: Cast to unsigned long in secs_to_jiffies() conversion
Date: Tue, 21 Jul 2026 17:28:19 +0200
Message-ID: <20260721152514.200189151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -537,7 +537,7 @@ static __always_inline unsigned long mse
  *
  * Return: jiffies value
  */
-#define secs_to_jiffies(_secs) ((_secs) * HZ)
+#define secs_to_jiffies(_secs) (unsigned long)((_secs) * HZ)
 
 extern unsigned long __usecs_to_jiffies(const unsigned int u);
 #if !(USEC_PER_SEC % HZ)



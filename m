Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F3947CA9C;
	Thu, 20 Aug 2026 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243952; cv=none; b=lZl4ybp6QTZMy5Z4nPS71l5nIPK/E4+i142XaUlieu+AiNDNzLiJ0ATtJXD70D1GU5QiRaxRdORYPmsaCVjn+KbIMlYCMekJkKiDQkk92tdpxj0tGis9CqhIligmQGjLumg3gSrvhtvnWKblaELxx19JdYZwrWqZ16GwEU0wils=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243952; c=relaxed/simple;
	bh=GXv3bJjt2OzIV3IxBmcq/UU93nFnNUAcJcVKNvmfDGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLfuNobDuDM7a+wPoYppAYlUvlwJhrOrrkruqZPWK0Y9MJNzgPxLQHJHD/o3LqlZ1lh8cVuWI2U1LDinHXtsjLZAvFMrbQYj0kW+5DHAtqBYxCI/Kpst69gpi2V8cwPEfUlGSSltiXRFd63l/ouLDNVDpcB1ohabdzjBh/v0svM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiY2r1AG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiY2r1AG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0CC1F000E9;
	Thu, 20 Aug 2026 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243951;
	bh=EmBMhPEbsajqpiMaHzi92gLweMGmJsknMq2ZZD8ofME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiY2r1AGHjSdIVUpoihgCtnx2tWr03ArEhZu+H+9Yt9HQFT7tL9zyOH7brGOOkduE
	 T9xsohDzC++ad0DDtn0Ohpeg0YyjKLzVephUlX+1ZfqaE0/k2k6yqOaibzdILqVJHE
	 7aQG4TQFfkqieeJAMLsIPSlN6mGOGIquOws8+wN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 272/272] jiffies: Cast to unsigned long in secs_to_jiffies() conversion
Date: Thu, 20 Aug 2026 16:57:36 +0200
Message-ID: <20260820145239.795140555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



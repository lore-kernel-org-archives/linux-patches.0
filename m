Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5D95684;
	Thu, 13 Feb 2025 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459707; cv=none; b=RFxrJvue3Fyh8fu6O/XPdRqjoFTgf9ufbe25cA6aWI42NRQ9xX7kCur80M4U7jopYcEE9Rzl50/0M8YE0pl6jbUgI0C3BzZPn91Y0rPT8X7vhsF+YgQ11Ekpq+beAjDln+eydv64qZrDI76zF9k9Un6+BZkzeUXRnv1dgkLplck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459707; c=relaxed/simple;
	bh=cxFJd/LA8LqPjCdCc7Jq8KnGP48DfnY+g6nS52G1WgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiR46rX4tmv4ljAx8wLyo3AIYD5vqA8eHNK/pnfnQxPYK8g/R8IBEUELrH1EFtWAasib8dqIwrnhr0qWu123naSWIX1mXNjyQK02r0PrEmjxhgvNDXBkLBrqlx1MtmYHKUkDSrfqNM3qraSZygQzi6Pl7+RXui/T1VytBxoSkSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARWEKuGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARWEKuGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7D5C4CED1;
	Thu, 13 Feb 2025 15:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459707;
	bh=cxFJd/LA8LqPjCdCc7Jq8KnGP48DfnY+g6nS52G1WgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARWEKuGWF46rCO+Ywa0RE4uqzl/39Uaju58Bu7z96NUk7+XPSg2C1BJtJP1Mzhyl7
	 ryCon30dMx+Nzk09WTl/bPCM70OlpH4gEa98dvWuqWawnTNadW7ZktcRA2hpO86AvV
	 +Zev2dmRh/IprEZK7Uq3BZRF8tNrAWgSDp+4cbFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.13 339/443] jiffies: Cast to unsigned long in secs_to_jiffies() conversion
Date: Thu, 13 Feb 2025 15:28:24 +0100
Message-ID: <20250213142453.706531432@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/jiffies.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index ed945f42e064..0ea8c9887429 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -537,7 +537,7 @@ static __always_inline unsigned long msecs_to_jiffies(const unsigned int m)
  *
  * Return: jiffies value
  */
-#define secs_to_jiffies(_secs) ((_secs) * HZ)
+#define secs_to_jiffies(_secs) (unsigned long)((_secs) * HZ)
 
 extern unsigned long __usecs_to_jiffies(const unsigned int u);
 #if !(USEC_PER_SEC % HZ)
-- 
2.48.1




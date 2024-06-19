Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F5112FB31;
	Wed, 19 Jun 2024 13:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802662; cv=none; b=To9r5Er1tdUgIWWglpvguk4HQT74u+bVZodRHrpE8cOUaLgRJqJE4izZAeFBGc5blevD8BOkd6z/zkIsVleQ/XlGAk5fdtg/3PFV3L2cpLgV9uWjR/hEK83qV2FI0MLD8vVFGnz8hmgv2L1NqiCT/WzcmHWELLI+M5N5lIwHaGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802662; c=relaxed/simple;
	bh=VrW8eYp/Jm6jMpg1/DTfrHEC3sXK3tqGbx3JNXISe1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6TLs1ktDU5Jbra+Y/wRc7yP6rWc2rAgTSVn/sTlwLphXNG1rulfdVR5oQuHC8HpxbRRY59uReD1OhVnNXnfjh4dUQzIqu5B9GzaOqj7uUBGaZTKRxijpvKjhVt54lNy1i9E0IhD6gTFBeuQN/CM4dr4E6EW5qXYvnG7Uq8SDkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/Y7oUz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/Y7oUz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4554C2BBFC;
	Wed, 19 Jun 2024 13:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802662;
	bh=VrW8eYp/Jm6jMpg1/DTfrHEC3sXK3tqGbx3JNXISe1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/Y7oUz5TdlrPI9q1hsPErpR+gP/xyLE3cxTOp7zKaPRDOC4Rjn4X9GfP7a/+D2V9
	 itdkC1xEpFfyu/Y8cx7HnPzPXW4OtUEYzjq/KsJs23bOUHJ1PnkZvlpAPFstDf3fJZ
	 GSnsaosotuYyi9MRz8yP0vfHqazNTC+IEP00bwgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/267] serial: core: Add UPIO_UNKNOWN constant for unknown port type
Date: Wed, 19 Jun 2024 14:56:49 +0200
Message-ID: <20240619125616.218783004@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 79d713baf63c8f23cc58b304c40be33d64a12aaf ]

In some APIs we would like to assign the special value to iotype
and compare against it in another places. Introduce UPIO_UNKNOWN
for this purpose.

Note, we can't use 0, because it's a valid value for IO port access.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240304123035.758700-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 87d80bfbd577 ("serial: 8250_dw: Don't use struct dw8250_data outside of 8250_dw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/serial_core.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index a7d5fa892be26..412de73547521 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -470,6 +470,7 @@ struct uart_port {
 	unsigned char		iotype;			/* io access style */
 	unsigned char		quirks;			/* internal quirks */
 
+#define UPIO_UNKNOWN		((unsigned char)~0U)	/* UCHAR_MAX */
 #define UPIO_PORT		(SERIAL_IO_PORT)	/* 8b I/O port access */
 #define UPIO_HUB6		(SERIAL_IO_HUB6)	/* Hub6 ISA card */
 #define UPIO_MEM		(SERIAL_IO_MEM)		/* driver-specific */
-- 
2.43.0




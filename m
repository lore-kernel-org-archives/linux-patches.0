Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9332037AA8A;
	Mon,  9 Feb 2026 14:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648230; cv=none; b=KA9kBnrZgyrHQ5vnEurSS90IMoC6D6xVjwy8mYYYLlRVDEcsjj2/62ZhWjCoV88Sxe8xdLiy/lTosVLv8bS1fWIrOHZddiRbKsS/AtkNlAtEWeh2HIH4qM28z04EJUO05JjY6OFwcbkh8DcDfdtlUCM4ApGlvVQkHE72dkJNeU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648230; c=relaxed/simple;
	bh=vaLhU65Xmk9aOATvLuc7mn4Bnf8gAPTXeio4nEC7h/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RBUJoSTWfx3Mkbit4G2+SRiABZ6XQrtO/8cOJH7hqtWjfQfyWKLUBa2P687df9+ELQB6DKUwj1qWQyo8HgZfOhtphq9/6KVprjdgIxGo++D5ftGaTlRNF9xSTjvD/W/qd+ctp1KjJVx29WzTmF58Bm16G9n+rbMPB3z65z5EG7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSwAX6/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSwAX6/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0747CC19422;
	Mon,  9 Feb 2026 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648230;
	bh=vaLhU65Xmk9aOATvLuc7mn4Bnf8gAPTXeio4nEC7h/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSwAX6/Okt1AFsVZhcYAN61D7Hr0MHkRsa7Dn/jPFGAlcKuAi9MT8Vzxuae2+JcxV
	 sc0QAPujAdGmSwUamf4lSd2otI/o0ocguCSiAfxmHjYqpPSkB10CWHSNdZw5A2SNjY
	 yjptatUAhk7TfeY374THsLQ0kI4XR6qyraDY3kCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 46/69] platform/x86: intel_telemetry: Fix PSS event register mask
Date: Mon,  9 Feb 2026 15:24:14 +0100
Message-ID: <20260209142303.580636114@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 39e9c376ac42705af4ed4ae39eec028e8bced9b4 ]

The PSS telemetry info parsing incorrectly applies
TELEM_INFO_SRAMEVTS_MASK when extracting event register
count from firmware response. This reads bits 15-8 instead
of the correct bits 7-0, causing misdetection of hardware
capabilities.

The IOSS path correctly uses TELEM_INFO_NENABLES_MASK for
register count. Apply the same mask to PSS parsing for
consistency.

Fixes: 9d16b482b059 ("platform:x86: Add Intel telemetry platform driver")
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Link: https://patch.msgid.link/20251224061144.3925519-1-kaushlendra.kumar@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/telemetry/pltdrv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/telemetry/pltdrv.c b/drivers/platform/x86/intel/telemetry/pltdrv.c
index 405dea87de6bf..dd1ee2730b6a6 100644
--- a/drivers/platform/x86/intel/telemetry/pltdrv.c
+++ b/drivers/platform/x86/intel/telemetry/pltdrv.c
@@ -610,7 +610,7 @@ static int telemetry_setup(struct platform_device *pdev)
 	/* Get telemetry Info */
 	events = (read_buf & TELEM_INFO_SRAMEVTS_MASK) >>
 		  TELEM_INFO_SRAMEVTS_SHIFT;
-	event_regs = read_buf & TELEM_INFO_SRAMEVTS_MASK;
+	event_regs = read_buf & TELEM_INFO_NENABLES_MASK;
 	if ((events < TELEM_MAX_EVENTS_SRAM) ||
 	    (event_regs < TELEM_MAX_EVENTS_SRAM)) {
 		dev_err(&pdev->dev, "PSS:Insufficient Space for SRAM Trace\n");
-- 
2.51.0




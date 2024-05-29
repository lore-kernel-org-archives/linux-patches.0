Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7651C68AE;
	Wed, 29 May 2024 21:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717018190; cv=none; b=r9fPXz00Y2Bl3JXNB4BNWrR9AlXok3Jv7sfHqQGPs6NlMqKlXG+3rNrWYTMBtCW1Q2/SxDEDu3mHh3GfIkN+1F4419A4Onm9MfnQ2irnp6aZq0d/dUHEVoOawFn14jaEiusFu7G8zL820RggbTNpZj+Gvu+btOhwr859Hnlak18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717018190; c=relaxed/simple;
	bh=YFT6XmkjuA1L67KGJ7Z/ys6g5VheO1R0g4CnaTAx/k8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ZJ2OkjYFh+WEOb2XbWHp6yRbooAUC21CCsY6wbCjuVG5PXQ60LnrbB6BDBKt4kqY1X8kwdhWtkPcm+yl8BB/434us5pqXGkMi4x50tzaptHq0U6AN35iFvTfhyM5qINZ0FONJ8n+rOi4zsvXnub5fFlbks5DBzLka7a6mTzlmXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=asbG9zBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="asbG9zBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576DAC113CC;
	Wed, 29 May 2024 21:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717018190;
	bh=YFT6XmkjuA1L67KGJ7Z/ys6g5VheO1R0g4CnaTAx/k8=;
	h=From:Date:Subject:To:Cc:From;
	b=asbG9zBDD1bf7uxNqV60imN7ol4BAKKLXWotP35uMcrJHa0RhgT2cS+6ozCmOPh/w
	 y2uZPaNg0K8HW/5YTGArGXaWr+2GV8XUMi33gJIQY8vd2z88Mm80t3d/sARC1VnegJ
	 BGRePAEAEV0mMwTozWo3kF9bozW0Lb62CMHvIrvHThLAryU6mT0k5Vw3ul8VnaZx4D
	 FPBI9HqC2VQsX1QnUxtZ2mQ4qT5+W384dW+wJTBkXByKhDBL+WW8De3EWlrJ0ABon0
	 SPYeTyt6la6Uvu7bLsPXfnTG7IS6YjXWwQ+f+7aBbm3hzQSQqZR3xZazc2BrZX+2Q0
	 Jol+y8m0KqzEg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 29 May 2024 14:29:42 -0700
Subject: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
X-B4-Tracking: v=1; b=H4sIAEWeV2YC/x3NwQrCMAyA4VcZORvYghb0VcYO3ZJpDjYlnaMy9
 u4Wj//l+w8o4ioFHt0BLrsWtdRiuHSwvGJ6Ciq3Burp2t/ojuyWcbFP2oRx/mI23wq+a3Nwtui
 MwhRDWIcYhKA52WXV+n+M03n+AKGQncdzAAAA
To: Jiri Slaby <jirislaby@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-serial@vger.kernel.org, imx@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2369; i=nathan@kernel.org;
 h=from:subject:message-id; bh=YFT6XmkjuA1L67KGJ7Z/ys6g5VheO1R0g4CnaTAx/k8=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGnh83zf105XVlO+zHNmhrKxdqlJuM23XWFdKTuZpzqG+
 Eo/nHKxo5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAExk7wOG/2ERuht3rcpyb7Ay
 +zCz+Hybv91x/r/M7bPL//9qdrjw7SPDP5WoQKHdR3Q2HRGTb/zYYcYlPWGz2R/WhwLhM2d/fdf
 MyQ0A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Work for __counted_by on generic pointers in structures (not just
flexible array members) has started landing in Clang 19 (current tip of
tree). During the development of this feature, a restriction was added
to __counted_by to prevent the flexible array member's element type from
including a flexible array member itself such as:

  struct foo {
    int count;
    char buf[];
  };

  struct bar {
    int count;
    struct foo data[] __counted_by(count);
  };

because the size of data cannot be calculated with the standard array
size formula:

  sizeof(struct foo) * count

This restriction was downgraded to a warning but due to CONFIG_WERROR,
it can still break the build. The application of __counted_by on the
ports member of 'struct mxser_board' triggers this restriction,
resulting in:

  drivers/tty/mxser.c:291:2: error: 'counted_by' should not be applied to an array with element of unknown size because 'struct mxser_port' is a struct type with a flexible array member. This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
    291 |         struct mxser_port ports[] __counted_by(nports);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Remove this use of __counted_by to fix the warning/error. However,
rather than remove it altogether, leave it commented, as it may be
possible to support this in future compiler releases.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2026
Fixes: f34907ecca71 ("mxser: Annotate struct mxser_board with __counted_by")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/tty/mxser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 458bb1280ebf..5b97e420a95f 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -288,7 +288,7 @@ struct mxser_board {
 	enum mxser_must_hwid must_hwid;
 	speed_t max_baud;
 
-	struct mxser_port ports[] __counted_by(nports);
+	struct mxser_port ports[] /* __counted_by(nports) */;
 };
 
 static DECLARE_BITMAP(mxser_boards, MXSER_BOARDS);

---
base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
change-id: 20240529-drop-counted-by-ports-mxser-board-ed2a66f1a6e2

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>


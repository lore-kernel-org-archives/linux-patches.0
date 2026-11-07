Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062099;
	b=ASK3Y6BrBF8ii8ZvlWzyZ35FleKGdiCrXsJcd5usm5jVcL93nKUrmKb/zdX+9LJz6UCT
	 O44E/E3F7C9RxOqGKYChuR5bS/H6Wk4vHQpKOdSj+1givyWxaav3fqOeONEkcRxWIpl34
	 vmPPdRAtJg0W/aSV3Sr6CW7QET26vN4uCTKE6CJXrOSwIuKApU8gYYiIgl82/fMvQz3eU
	 b8tAtDxQ/R7oPqWUJiBynmj+2l4F225dfNuF+tLwRsfTLut2ParaL2cFRJwJ21rfPwmlP
	 kJh2br/EuKhTIuCQuOpVySExUukcOY5dFMhqXiI0VEJ1rB/DaotqEmuZ89y0HYvk3DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vlFuRwBBw+eyZ+DITllc1mefh7hT4Hs7lui0efca53A=;
	b=yzZz4lESi49bhVVDDWX0d6iRUuEFX8TKmBaE+d6QnefK/S+2wSj6KZhZsO5yhnPIeS8/
	 CrRFLdBaO8I/UNsqw4YACW2UowukHngsooomDYpXUR+8/rREvum2XpuNVKtOYxEhyAe0+
	 20o5tMOM9HfYV48EaknnSM09qlVZGLtbo6n1m3R8G0+ioZGmjfLkHWGpRWDdGIq+qtnAo
	 UKjE6QxKatmuCs9g1sE9CDLPaM2zSb3/0LXvnmoeMmXVgwSYOHI6XEoQgqOUk7hMBpi29
	 GA1C/qaM8hDEcf6+Qg5TNULR5dFIO67T/KmleiYwJYY6xTezEUGRoQOSz4nbniGWsag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMNH3AfM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7CA60A2610;
	Sat,  7 Nov 2026 14:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMNH3AfM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9091F008A2;
	Sat,  7 Nov 2026 14:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062098;
	bh=vlFuRwBBw+eyZ+DITllc1mefh7hT4Hs7lui0efca53A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMNH3AfMJtw1gAz1w7SrhI7D4uL554JJVlYDZM5WfF5bCbQ8oGtWWjxY3hnypX49S
	 jPtIgNvce0WPrTUnnmRFNJDgJbCVV0rl/a4PGVFcSloh+1dYyFVLQIb3zhYQGY3rJV
	 /PopdSc05whTwfJCotNWuok9FkzF5Z2PummkOqyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1034/1536] crypto: amlogic - Fix IRQ handler return value and fallthrough logic
Date: Sat,  7 Nov 2026 08:50:50 -0500
Message-ID: <20261107135026.715521476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

[ Upstream commit 4b8ae2732070c5669adee2d5d3bb97b14af53a63 ]

In meson_irq_handler(), when an interrupt matches a flow but the status
register is empty, the driver prints an error but doesn't return. It
falls through the loop and incorrectly prints an `unknown irq` message.

Fix this by returning immediately. For empty status registers, return
IRQ_NONE instead of IRQ_HANDLED to avoid masking spurious interrupts and
allow the kernel to detect interrupt storms. Also use
dev_err_ratelimited() to prevent console lockups during an interrupt
storm.

Additionally, the handler returned IRQ_HANDLED for genuinely unknown
interrupts. Return IRQ_NONE instead for unhandled interrupts.

Cc: stable@vger.kernel.org
Fixes: 48fe583fe5417 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index cdb5ac1a69916..42d08a48b1806 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -37,12 +37,13 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 				complete(&mc->chanlist[flow].complete);
 				return IRQ_HANDLED;
 			}
-			dev_err(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
+			dev_err_ratelimited(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
+			return IRQ_NONE;
 		}
 	}
 
-	dev_err(mc->dev, "%s %d from unknown irq\n", __func__, irq);
-	return IRQ_HANDLED;
+	dev_err_ratelimited(mc->dev, "%s %d from unknown irq\n", __func__, irq);
+	return IRQ_NONE;
 }
 
 static struct meson_alg_template mc_algs[] = {
-- 
2.53.0




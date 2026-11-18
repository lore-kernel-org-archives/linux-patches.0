Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016612;
	b=qucVfUh+srXw2DPExR4ozMEpwQ/FMQx/BzRh5TiYt4dltkOt7WJsuamz3wEDEgEWk9z0
	 4IBLEZvSBAM+QNaXwmo7PuFQ0LTE6/H3SJju9o/eo2Oq+D1tlXDeKRxW2ZL7bW7+zvdrs
	 k5fWrvNlSKHblCFCy6WI4FcvX/5qDvZOAWgssYjyoXWWf1bfOwoAdw1kivlUna6G8E4Up
	 67Us9LQ2Psv4rDHzzb5kcyPkq/6z5GW5+ouxYF1EPQRu4Vrl9WIJr2Zf53pWUNBXmhmtv
	 ah/1/+8JJOL8DlrVUyU/TyvTz/h6xScABnhCbAvfK6M1yLjQeI+1Z2xS2hIcsTGbZVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zZSZVHuyNxkl+Sf7ODrH1JxP4NAxZNDdvrNaAfW3P7k=;
	b=qWEqOIUhxudqlGaMa9Es3ci0r34NdaACg7x/fx4FhjXeS4fqQ3GxcnJQ7AfPxVwfMmez
	 h6rT8vH6lNZnoH+dhE5JirHAM3om0wJAWYQngY7tZD8yP1VXLIm2YdJ/7qTsmfZLoitW3
	 +pspcuszN6JmW0jzdY03eNZQWmOu2N18ZHTvnwBqPCy2Xh7/nOvqcKGK1AXaShEX0aqW4
	 jJ5sXWi2srSsblJ1K5Rl//+GpNy9WPm+8ioUFIxu47TmTZiolocZJEvwG/kBhJghSqXaO
	 KtjSYocLNnVNV91eMCSlR8WuqSo/E10RVZcF9SKLdG3aygKkC8mkVlGrAqd4h9VqTJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MogkBYtH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDE1606A320;
	Wed, 18 Nov 2026 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MogkBYtH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906871F000C4;
	Wed, 18 Nov 2026 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016612;
	bh=zZSZVHuyNxkl+Sf7ODrH1JxP4NAxZNDdvrNaAfW3P7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MogkBYtHwKHd4dJr2NPPSwp4tLl36GlWYhzwYc3eJmjE+fBLKXGrBB3gZ3/egzNei
	 FGQW1DxGRiu1ppAUBKWCsVsCyYe3v5JBvy0+dnAueWTr94uALxacBHwebih0Ovv7Rr
	 RyocnyNLVWpu1fV5VZ53Ja7ViUhgh4SEIwFMafXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0589/2651] spi: mxic: fix ps_clk leak in runtime resume
Date: Wed, 18 Nov 2026 15:30:29 +0100
Message-ID: <20261118150308.926484496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 648e3c436032b675b339662ea9c0edd9221add76 ]

mxic_spi_runtime_resume() enables ps_clk before calling
mxic_spi_clk_enable(). If the latter fails, ps_clk was not
disabled.

Unwind ps_clk with clk_disable_unprepare() before returning
the error.

Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260902-mxic-v1-1-76806325826d@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mxic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mxic.c b/drivers/spi/spi-mxic.c
index e3c85e5191e36..481edd4b35cbf 100644
--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -744,7 +744,13 @@ static int mxic_spi_runtime_resume(struct device *dev)
 		return ret;
 	}
 
-	return mxic_spi_clk_enable(mxic);
+	ret = mxic_spi_clk_enable(mxic);
+	if (ret) {
+		clk_disable_unprepare(mxic->ps_clk);
+		return ret;
+	}
+
+	return 0;
 }
 
 static const struct dev_pm_ops mxic_spi_dev_pm_ops = {
-- 
2.53.0




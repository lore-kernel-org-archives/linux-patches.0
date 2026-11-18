Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036103;
	b=jYlWlITMyB12G7l/HjeFnxOSXbY04yFuMzLfj+Kj6J6U8mj6M6D3kSwnDZLde6u33EtV
	 TfcvlbMhsgfyjBtjbxWoUdh3UR3xAb+Om+0Gx/EQi3e0WhAmRRnVy0QEbxhI5iMpK2tDs
	 EvC1M2EF3ishJuJw64zmprXT/C+m1X0XNuRYtDuasFZbiNc3e0wUGlZDXSCSPDClGuJy4
	 rpKcn6SEyaWY6KO2NZMM+yQ/XAKZ6FZn8LmKtZyMatBfroc0r1twEIVBOOf0NmSSd1HqX
	 cNutxUM8I13xZ1Yh/98XphGApPSHnZZ0RKopfpCzxTc+XZXZ6aKIjOs8GBSElGh5Gtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hQLVpT28ZZyovZpSBbcsg5jcL/but0sJEniI5cK3ViM=;
	b=oRWx+rhwaMGLIYN2momLkSsmxus66s5VFKy8ibBFTgpBxL7GHm1PDg5RBleIJQHVjCVb
	 3eBL63htg3LOLGkiIqWSuz8UF6oSSu01vSrBbqKnJJL8b0EiOaIcI34nrS9FCDGVy6lv4
	 qrzaDA17FXzx4Ct/KPE41RIc4zWJ35DMRfU9y5eCLXwd8zcLB3dyedQERlGl1ie5lOCRJ
	 BunDg5HNqSl8TKj1OO9Id7WMvbO8Jggy4Fv9Eu9bZUJ5ff+Pta2tCF8U5hdcskbqFfVNL
	 CWcwvbBqiKo/yy3kDVoeYYVwQo0kcQTQhJ1lm3XXnUkOEQmWM9Gk5jy5JTO2GSRvmEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhFkjvqt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8887A606A325;
	Wed, 18 Nov 2026 21:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhFkjvqt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCAE1F000C7;
	Wed, 18 Nov 2026 21:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036103;
	bh=hQLVpT28ZZyovZpSBbcsg5jcL/but0sJEniI5cK3ViM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhFkjvqtSeFmCOgSw2HrgfS+gbKxOG3ND5IhhhCMUS2q3BaGZsU9jnyFwbHpsUTY4
	 VubTbDymLlIH6qElxOxClvQce3FGHmFj5m436X2G6/w2aWjaxFme6JDcVWAv2TuS8V
	 KYDBOdJ0gQNYPgg0QQ9UPpOUJTSJ/ang8AhvHCOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0923/3318] media: vpif_capture: Fix i2c adapter reference leak in vpif_probe()
Date: Wed, 18 Nov 2026 15:25:45 +0100
Message-ID: <20261118150347.223546347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit b00fbdad64d4ea7d594bc67988c1722fe5b3be50 ]

vpif_probe() takes a reference to the i2c adapter with
i2c_get_adapter() and passes it to v4l2_i2c_new_subdev_board(),
which does not consume it, but the reference is never released, so
it is leaked both when the probe succeeds and when it fails after
the adapter has been acquired.

Release the reference with i2c_put_adapter() on the success path
and in the probe_subdev_out cleanup, and initialise i2c_adap so
that the cleanup is a no-op when the adapter was never acquired.

Fixes: 6ffefff5a9e7 ("V4L/DVB (12906c): V4L : vpif capture driver for DM6467")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/davinci/vpif_capture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti/davinci/vpif_capture.c b/drivers/media/platform/ti/davinci/vpif_capture.c
index 5c2f5ca97a59f..0da336b439022 100644
--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1604,7 +1604,7 @@ vpif_capture_get_pdata(struct platform_device *pdev,
 static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
-	struct i2c_adapter *i2c_adap;
+	struct i2c_adapter *i2c_adap = NULL;
 	int subdev_count;
 	int res_idx = 0;
 	int i, err;
@@ -1694,9 +1694,12 @@ static int vpif_probe(struct platform_device *pdev)
 		}
 	}
 
+	i2c_put_adapter(i2c_adap);
+
 	return 0;
 
 probe_subdev_out:
+	i2c_put_adapter(i2c_adap);
 	v4l2_async_nf_cleanup(&vpif_obj.notifier);
 	/* free sub devices memory */
 	kfree(vpif_obj.sd);
-- 
2.53.0




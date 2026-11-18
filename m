Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024839;
	b=cL+av0niWW9oEXYQlGy6ZY4ryMeSCEzfYQ4Twu7hya1gNrVYU2wLbJGvX22ilcSjvYaV
	 IUKWR4YV3iL0QS2aXQifBJqB9zqLTJnQboSEH5+I+SCWSbZ3XtTpUJ5vYYBw/RzI0mgKs
	 6YWcEqZ0MtuyZuAwiktiuyK2y4aYpsQfxbaCzQQyWd01RMhb+6Ula+GexnWrhljek2ECe
	 T8xXcs5C2eY60plSWM8eV9Q/C4l/UXwU7Cz2Ue4OEOExEsEmNEdOEGBOjTb7/4vUySjj/
	 TiCVxNhMRnbNVwXg0L6zNIN53CF9ZSZCUSnJOHrMey8PdvHUVt0+sKL8dW0NmqiXF3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wBnV5keoNB8uHTAspcgSkACVaRXInuc3vhctzU1NGRg=;
	b=rMxy1hVFuFi0UMssRBOfgdTPhVsj8W2sF8za3Njir/Sq2xjiOL1Wg0kC1Sv0fJG1cRfl
	 jOWRlNZf0K4JivUEUQDrRonIxeQN3dkkFf8IiMtQ/bLQustO+jTGBPMzfZ91VkC8usHUZ
	 AxUFHU6tgLDCrF5Ld3/F98YMvSgMKVEm2zrfciGqDi20lBcpZmFWMM2IHxQNhrW94zgw/
	 uVUn9U43kYgQf2qfUKtwSMaEBDDmpimqSVd2DwJip1w406R/DrlhRWZYldmmaq6jtG85A
	 kDvrQzdQ87k+QlCdaxjfdBpnmWpcoRFcikoPJl8ICoGbd9qqqe+idR9BK1/OSW//xUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdi1H5xt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB90606A320;
	Wed, 18 Nov 2026 18:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdi1H5xt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88B61F000C4;
	Wed, 18 Nov 2026 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024839;
	bh=wBnV5keoNB8uHTAspcgSkACVaRXInuc3vhctzU1NGRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdi1H5xtxcwMOGwVGeub7O4SonsLyliMkP9DZI5PgTaQuBdjoHHHO/SQ4IgYF/tkl
	 kWYCEnbyu5F7vOSmHBsVCb2CUecbbZLcj6Udor5c4JgtxHyS4pLew5oDaR+l+dAQNr
	 b9uvKkeHKM49u40JLkjCP9qbtpRCqsj/avtqQt2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malte Wechter <maltewechter@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0865/2151] rnull: configfs: add power to configfs features
Date: Wed, 18 Nov 2026 15:43:20 +0100
Message-ID: <20261118150153.724051116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malte Wechter <maltewechter@gmail.com>

[ Upstream commit 0cd698e89375d0dfc257f9ae978420aa7fe5359d ]

features displayed by configfs for rnull was inconsistent with the
actual features available. This correctly exposes `power` as a feature,
which is also consistent with the C null_blk driver.

Fixes: d969d504bc13 ("rnull: enable configuration via `configfs`")

Signed-off-by: Malte Wechter <maltewechter@gmail.com>
Link: https://msgid.link/20260924-upstream-v7-3-rc3-v2-1-ca56ae7a73e9@gmail.com
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://patch.msgid.link/20260929-rust-block-for-v7-4-rc1-b4-v1-8-642a4c1aebd7@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnull/configfs.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 8498e9bae6fd1..5c08edc7f2840 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -36,7 +36,7 @@ impl AttributeOperations<0> for Config {
 
     fn show(_this: &Config, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
         let mut writer = kernel::str::Formatter::new(page);
-        writer.write_str("blocksize,size,rotational,irqmode\n")?;
+        writer.write_str("blocksize,size,rotational,irqmode,power\n")?;
         Ok(writer.bytes_written())
     }
 }
-- 
2.53.0




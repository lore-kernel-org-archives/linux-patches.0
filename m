Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BCA20C012;
	Wed, 25 Feb 2026 01:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983343; cv=none; b=YXwufA8B4Y4cGASbrd0Mw6Ew5bAyCA6HgeNh9s9mGNM+6swEoKj3GzuebxHHNSZTWnsigyfzva7RN5PH/pAe6HNp4kmcHk+uloW2dYZxNM5NfZ/y/COEkR8n3+UrAC7/oXWKPvG7qU5cGdJmoF4KRw/yr4KHlF4NMT5rlpZxHMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983343; c=relaxed/simple;
	bh=YuAqcOP4B+sQQYviASQqjrJbu/vouCmmHgMkXXuzaV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uV12LL/HRn+99hn8iLJv2XGw/9nQniPo2USh8v+L7jBXoUUJ/JmQVYbJVyuHFqpHFmedbCsdxBtIFe4CuMTzthnxiT0nvchol29vKSE6JqoUpIcHqCuX74p8tFS3O+0zfvR/5e4d6OQ8e2LJlC4hGcWeKkBoXQFGggdadby9Yc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oo0ZFRnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oo0ZFRnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475C0C116D0;
	Wed, 25 Feb 2026 01:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983343;
	bh=YuAqcOP4B+sQQYviASQqjrJbu/vouCmmHgMkXXuzaV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oo0ZFRnYU+CNl9/j7P8XrfC4m4h89HvDEp6JYvxYNFte7FKYxofPIM1GSgKtTtaFc
	 yxwoQe5CWbv9ovVD49jeDwIsJtqOi1a9lxxE4EquC6eu5BA67WqlpApaPsTesAhpqb
	 Ngd0OUf4RVsnWxRQYYS63Wz/vbFrP2hK5aqeOlLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijun Shen <Yijun.Shen@Dell.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 472/781] crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
Date: Tue, 24 Feb 2026 17:19:41 -0800
Message-ID: <20260225012411.394460181@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 5e599d7871bf852e94e8aa08b99724635f2cbf96 ]

tee_init_ring() only declares PSP dead if the command times out.
If there is any other failure it is still considered fatal though.
Set psp_dead for other failures as well.

Fixes: 949a0c8dd3c2 ("crypto: ccp - Move direct access to some PSP registers out of TEE")
Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://patch.msgid.link/20260116041132.153674-3-superm1@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5e1d80724678d..af881daa5855b 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -125,6 +125,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
 			FIELD_GET(PSP_CMDRESP_STS, reg));
 		tee_free_ring(tee);
+		psp_dead = true;
 		ret = -EIO;
 	}
 
-- 
2.51.0




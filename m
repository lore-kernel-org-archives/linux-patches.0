Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049069;
	b=f3jS+o7vFOu58ba6qQ4V21RqFSrMgK97T+zXscFFmmHu87/td0yKJTRw7jmhJww7fTAu
	 57khQlzul5SHVP3fOUr0lPqiFwu1Jldy8lwuwAJx0MnSjazhb01OZgfx3ZV9NtOtY6z8C
	 3OnPaT5FQSqgiH9XCJKYnZeCF2ZAoGUX2O6HnkBEIWTavQcq71WJM6pA6ivb6tpUjKv9y
	 c0BblGTe3AK/J4nBAGyH2sK9vlWRbdGVgcSzc8qlnvZz02AiGMFOob9Q6XkG1gFiT9If5
	 CnKRm8l0tuc+kkhDIc66mfUlmPrn4/V0qKqAtb3B9e4yzkK/WtXLkA94rK7URUCoDSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y35+GcXCuKXIuuVmpMsxombZsNxpUxuGBC04vp88SdA=;
	b=IqLF/5kHCRUO3dHL8DljKjlppitpzCsraoKpUY7gmuIGqYHwZydnD4y4CbfTJP6XCgEw
	 ZF2o2zCnfmobUGs6Roqep1rr413yHHVFjJ7CYH+PdWxfxCmmOAXfFXuVq4weaIl+pEFBz
	 uK0B514qQJWlQgqAGVxHX+04F2Mp5FFaSg8kOCsAILEmvmUiw1Y8i49NWevtolMrJoaJl
	 29sddaOauEP2pU1HgsPwJ5zgpY2qkr9oFr1g6Z2c0hmSPzctsRSQ2HPPJ4iPKBdupwkOK
	 frq/kXvuwUoQ4A8UeTJIwG37g6yXlTPv8UwBWIKrKFi/bsvy80JyC9Z9GvOKufIbD3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AIir8Qrn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EA3606A320;
	Thu, 19 Nov 2026 00:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AIir8Qrn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB9C1F000C4;
	Thu, 19 Nov 2026 00:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049069;
	bh=Y35+GcXCuKXIuuVmpMsxombZsNxpUxuGBC04vp88SdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIir8QrnfG+HHcdvQDMHPbui6Gn4vqMKuipkAHeIa0HIjKhY6Lj/fkLVpFU84P6dr
	 NF3pLuUP6tZmc+j1RW3KKLWqvVMwC13Eq8uu09faPHY3qUVPJuWqTu08DbnJycma05
	 rHFTsVO01F93Iu+7YZ3/4FFh/msu33mIh0QCFl34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2219/2857] ASoC: rt711-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:54:13 +0100
Message-ID: <20261118150321.312577819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit ecc2fca6decefe27d8cf40a4c9815798eec24d30 ]

rt711_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt711_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt711_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: ac63716da307 ("ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-4-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index 931dbc68548ee..c0c85a88704ac 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -365,10 +365,8 @@ static int rt711_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt711_sdca_priv *rt711 = dev_get_drvdata(&slave->dev);
 
-	if (rt711->hw_init) {
-		cancel_delayed_work_sync(&rt711->jack_detect_work);
-		cancel_delayed_work_sync(&rt711->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt711->jack_detect_work);
+	cancel_delayed_work_sync(&rt711->jack_btn_check_work);
 
 	if (rt711->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0




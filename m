Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02823F23DD;
	Tue, 17 Mar 2026 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766087; cv=none; b=WDBUx2pDDzl+mxptiKSn5az4ACvjIA6ZmZPr6U8BfMWfaSSYVHQDmpDtUXhoDDZpxjYOoTW/e82T5245r/8toJV+XwJdEMwB18v0AlXlFuODoYvNVqMiKZQPk5PqnbJgjhSgd5pqaA4HbC2DvSD4k+x8sfpAh9vJS5x4hPr3eek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766087; c=relaxed/simple;
	bh=Vpzd5vCZaO49Q75X4gu14LIWsXCxwlX5M/Ph5Uhr71A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP1Gsi5w791oOvwdG91OgwOGLxAMXDSd+pT/TeLIvwG5MEqW+SfohiGJZpoBup4TYGuQGz7X3udqtn1LjN4Az12VSWRyr/tWXHUMLYkaQeLGaYtnN8B1YkHGU5uCBr10K67guvBu4sUgi4D3iSYmlig5rSpUhDJS6ogyeUlvUPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnfJGzrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnfJGzrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B75C4CEF7;
	Tue, 17 Mar 2026 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766087;
	bh=Vpzd5vCZaO49Q75X4gu14LIWsXCxwlX5M/Ph5Uhr71A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnfJGzrRaXUxhh787I1uajbsvX6CTmhW5/dyD3fMylxw0M0qe7YRtB+8K4a61VsY4
	 WPRWiN4dvYHcuaG6MA/SHbnfjZlLnejRTFwB+CJo9ABm+fXNjKCde+cGFh8lojVnDJ
	 byhN0zBi3/yUdsAj0CYNz3hXA2ee0MnhKjrtsuf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 134/378] ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK PM1503CDA
Date: Tue, 17 Mar 2026 17:31:31 +0100
Message-ID: <20260317163011.944714627@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit 325291b20f8a6f14b9c82edbf5d12e4e71f6adaa upstream.

Add a DMI quirk for the ASUS EXPERTBOOK PM1503CDA fixing the
issue where the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221070
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260304063255.139331-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -710,6 +710,13 @@ static const struct dmi_system_id yc_acp
 			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK BM1503CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "PM1503CDA"),
+		}
+	},
 	{}
 };
 



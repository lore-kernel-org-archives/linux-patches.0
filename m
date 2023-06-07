Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769873922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11E4C4339B;
	Wed,  7 Jun 2023 20:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171406;
	bh=zEgrazDcCfPtDQWqVRHZCNr7MT17in7QkAQ2bTDJKkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpSlUtPJSKvMWLLPvjfnQpV5LK+7+PNU7MVPGRn/pOjmvPFrTUPW4zdD34Y0yqQxt
	 nomttjGCj/D7avbHlT5krslVvMdOEkGmdr0eyZU+378389TXYKXVXWc5xohi800318
	 FPsVRc9cD/EmjO9xq0ZZAqfbtSB7b14/bcoRlmV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Valo <kvalo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 81/99] wifi: rtlwifi: remove always-true condition pointed out by GCC 12
Date: Wed,  7 Jun 2023 22:17:13 +0200
Message-ID: <20230607200902.761419461@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>
References: <20230607200900.195572674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

commit ee3db469dd317e82f57b13aa3bc61be5cb60c2b4 upstream.

The .value is a two-dim array, not a pointer.

struct iqk_matrix_regs {
	bool iqk_done;
        long value[1][IQK_MATRIX_REG_NUM];
};

Acked-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -2392,10 +2392,7 @@ void rtl92d_phy_reload_iqk_setting(struc
 			RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
 				 "Just Read IQK Matrix reg for channel:%d....\n",
 				 channel);
-			if ((rtlphy->iqk_matrix[indexforchannel].
-			     value[0] != NULL)
-				/*&&(regea4 != 0) */)
-				_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
+			_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
 					rtlphy->iqk_matrix[
 					indexforchannel].value,	0,
 					(rtlphy->iqk_matrix[



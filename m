Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9766B3451B3;
	Thu, 30 Jul 2026 15:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426934; cv=none; b=jqedjn/zYuuqQLuhjDaSYGfzK2UfmzFMXs9kq4JACKofLke5gFi/vT1fTxAPSqAgh3tVdknvFfIwKFXKNQBgTlbw1YQxMSWTjeWmC40PgX/H55j1/hw8H2JMM8A1Ug8aLRhjAw3vazrMhk9pCkX1K6uUMn2OPVN8J5DwgbPICnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426934; c=relaxed/simple;
	bh=ch4aPgl2XMHwvuhNmJAbS6+/Y9mwFVrhgtIwNqe2Mjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/9tpgB0v4N62p859XNNLKm03XfqZ3e3TMgr50nSKD2OahumDRyL5ErImt1DUgroTgb2/5uLV+4CSRs6b/qdLPN+kgreDCt665giCf9J3Eyv8iN0aVSu1lnOCzyNtQMUggcJtcYVrl2mst4lvRmBQKGDTVD3BJLYcdaSSjQORUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHkve9C3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHkve9C3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F320C1F000E9;
	Thu, 30 Jul 2026 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426933;
	bh=pDfoUo+MDbvNq4Y7n1cRptIk1idHtp0OqubNDcmjb1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHkve9C3VmUkikVq5cEf+iXkGFVp4hQwKLbP+A3zN0PggJE44y9cpcGb23uCvFsVQ
	 2mlPBZF8kR2D8HU7sRVTJpYXdcy0+x2RLl02TQIkaDt1m3g7VZYgd7rJqpTAWlQkh7
	 xw9C5+9V7qhEBd8pyA/Xs+1yqnnHAfBFtOlfnpsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 592/602] net: ethernet: Remove accidental duplication in Kconfig file
Date: Thu, 30 Jul 2026 16:16:24 +0200
Message-ID: <20260730141448.495002615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

commit e2537326e3b6b1bb18f834ebb80b8453c0018883 upstream.

Commit fb3dda82fd38 ("net: airoha: Move airoha_eth driver in a dedicated
folder") accidentally added the line:

  source "drivers/net/ethernet/mellanox/Kconfig"

in drivers/net/ethernet/Kconfig, so that this line is duplicated in that
file.

Remove this accidental duplication.

Fixes: fb3dda82fd38 ("net: airoha: Move airoha_eth driver in a dedicated folder")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250306094753.63806-1-lukas.bulwahn@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -21,7 +21,6 @@ source "drivers/net/ethernet/adaptec/Kco
 source "drivers/net/ethernet/aeroflex/Kconfig"
 source "drivers/net/ethernet/agere/Kconfig"
 source "drivers/net/ethernet/airoha/Kconfig"
-source "drivers/net/ethernet/mellanox/Kconfig"
 source "drivers/net/ethernet/alacritech/Kconfig"
 source "drivers/net/ethernet/allwinner/Kconfig"
 source "drivers/net/ethernet/alteon/Kconfig"



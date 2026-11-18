Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040541;
	b=JCLquEKVrPEnxiM3YEYFOdZ336p7dC9pbJWj/9AvyWAh6oJK/EHlLErPhp7MzQ65q8mY
	 n9d6I1WbcF3iXVAfsr0EiSvCDoLXE2YVMimHRnbwbCUWvKOQhIUuogegXEplXVmBalLhn
	 L9IaFwrle0/qtL/0dcGcqAxTOKNVHBIsqQ1f+jb3z+A1AVag6Ey6wS8SjZQ46DkWuvEL+
	 5ZLDnap6ROa+kyisJkqlvj/Xcs2DqlAtHPPGFvQ+OEuuSe9rYXxlZ6EYqyiZaEco8i1Cl
	 dZ41qV8lkXF9dQLQrFLWc1hVzhgUHyz5tP4+Q8FFi+AY9EVstPiaOZCSHP4+BTjolbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ARBZ6dSTI/v0mRnEc7NAg5puTLVwHVn2qRnXFbbsz14=;
	b=WvHvBNBhGixwxn5NT9vSju53ZTZ8Q8dSyT8gcYRod5ROTx445cEHgPpdkPs8jTILchem
	 JjQRGlYtCXmoNJ/OPD+gOL251eYp1C1pZGllhaL6afaNpflS33BH4dM33euT7YWIDHR5i
	 PC5ebcf/hHvVqdDoJgKK0XPw3l2g+yQPBjLa+LCZoWXT/CJ1kCemwP1pluA4K36uf4uuy
	 7kKUPx70ChzFrB4nV+aYmiM4NWsttZyBOldiMoMZYIjqFcz+OW/rb7TqG7T7RA7az2pTi
	 m3Q5ZxiwJEFsK6zZhKeV6DOteAJSvXNb0KOJKptYA6vr1aEFUdSXFgW3GE2uXn/Xfnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZAF+8Qm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564EF606A32A;
	Wed, 18 Nov 2026 22:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZAF+8Qm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64141F000C4;
	Wed, 18 Nov 2026 22:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040541;
	bh=ARBZ6dSTI/v0mRnEc7NAg5puTLVwHVn2qRnXFbbsz14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZAF+8QmasxRyV2zvl14T+3QI4qp/uzL6qPh1WFOsfvmIlTYvkvkuG79nniPOFwj7
	 cYFEkHDzMvJ5xXnYRvQYOM8nZyiN+t7pbJhV2Xltoplr3VJjtlVGma6gV2rPD1BHxn
	 i8Wa+NIJTyucGQTPF+H+M9Ms6G5XNUpnn1AlZO+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2453/3318] clk: ti: adpll: unregister OF clock provider on remove
Date: Wed, 18 Nov 2026 15:51:15 +0100
Message-ID: <20261118150435.028150836@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 4c943ddfc24340f1b899762b1ff35c38306b7a35 ]

ti_adpll_probe() registers the driver's onecell clock provider with
of_clk_add_provider().  The remove path only frees the clock resources,
leaving the provider registered after the backing data has been torn
down.

Unregister the OF clock provider before freeing the ADPLL resources so
the provider no longer points at released driver data after device
removal.

Fixes: 21330497f303 ("clk: ti: Add support for dm814x ADPLL")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/adpll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/adpll.c b/drivers/clk/ti/adpll.c
index 8b76c032f7d07..f76251bb950c6 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -931,6 +931,7 @@ static void ti_adpll_remove(struct platform_device *pdev)
 {
 	struct ti_adpll_data *d = dev_get_drvdata(&pdev->dev);
 
+	of_clk_del_provider(d->np);
 	ti_adpll_free_resources(d);
 }
 
-- 
2.53.0




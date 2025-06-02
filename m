Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D3519EEBD;
	Mon,  2 Jun 2025 14:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874625; cv=none; b=qfVHKbMdY/NqCBsq6HhdhI8elZZXlb0rHSxLH2nfcOsEhdBN4lcvNXcDcLtMl03uhTccK8cMcmpYhMjO0KouRXl4AMhFmpbbYidc7Xsn79OCwl3fUUZshsCTKWt8zzvi+qNI6Kmu7IRqo3gH2Lo70koWWkRZt2DrFe/Jp6l7gu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874625; c=relaxed/simple;
	bh=cxhWKODbK+hNUHH5irpi6XgMDVSBApdQnQLjHfIH7R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcW456hMyMk2ALuWawdmAafSukBcO99lN/SewRHr2lPd0/gSG8uLiXPb+TyxkIZ564toU5qRF1fdQX7lyCiHhg8eqdr5+Mpw5nqT9cbufB/0t1gl9Y8Q+e3CruhrdJXSfTvAj5Bmg66otRVnl+0yHgE+ebrLkNcgH/no+kh//vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqPMbBbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqPMbBbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DAAC4CEEB;
	Mon,  2 Jun 2025 14:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874624;
	bh=cxhWKODbK+hNUHH5irpi6XgMDVSBApdQnQLjHfIH7R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqPMbBbFr7l7+KPPsxcM2oNjf40vhoxFoQKQ4X2kJdj6HKcnE6cK+vSn+qtVVaqJ1
	 j6UjjZQw6Sl//MpriqskQUMwZf5LAT390jFBy7lUZA0eN3NErv1cJZvwL9AQ3Eri79
	 Lm9YgGaZD2w6GRZ9ti9fasYBVeBmDD6YuhPrNSQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Eilert <kernel.hias@eilert.tech>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 084/204] Input: synaptics - enable InterTouch on TUXEDO InfinityBook Pro 14 v5
Date: Mon,  2 Jun 2025 15:46:57 +0200
Message-ID: <20250602134258.969478546@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit 2abc698ac77314e0de5b33a6d96a39c5159d88e4 upstream.

Enable InterTouch mode on TUXEDO InfinityBook Pro 14 v5 by adding
"SYN1221" to the list of SMBus-enabled variants.

Add support for InterTouch on SYN1221 by adding it to the list of
SMBus-enabled variants.

Reported-by: Matthias Eilert <kernel.hias@eilert.tech>
Tested-by: Matthias Eilert <kernel.hias@eilert.tech>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB9597C033C4BC20EE2A0C4543B888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -186,6 +186,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2044", /* L470  */
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
+	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */



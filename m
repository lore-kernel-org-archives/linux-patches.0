Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B787978B4C;
	Wed,  7 Aug 2024 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043067; cv=none; b=u2vDuXXFB4t3C0SkgtLKvx4MlhGyRG4adRNsNQGtsnNc0G5qeQUaGj2m1vQEQtLE4dn1h3448xlWhqpmVlwGOD59Dx8e5zHLCQzfBIbHCu/AqL3EAB26E7pY+k+JsP7Bje/uz/68SdmNeloyyOqDDPIcr8vnR5/CygPGfdeqok4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043067; c=relaxed/simple;
	bh=LJ/SIndGN9b9cNuyvMuNn0iIfdd0FgDF19wezs4ggKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4n4YhB7Az4NKfEYhfa0GOmceJJ5p6VhMk+SYuk65fAX52R3xL7AUB3lDge3jEX9ZlkQFPu4iTT/2J6+ezwKELiO7OfqrGAa5hp6eP5Ou08M3svLpYvAejFKgVBP1TN8zn89v+U55qLnbm16fnBK9+KtVptlHDTiWvgW6Y2pw5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2MgH1tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2MgH1tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451A9C4AF0B;
	Wed,  7 Aug 2024 15:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043067;
	bh=LJ/SIndGN9b9cNuyvMuNn0iIfdd0FgDF19wezs4ggKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2MgH1tkSVSwBmvtWuJ/+RJHtAMImlU1qpUIN4ugBzh9pqoqwzUgRZuJoJhGx29/x
	 3ZCFBQuSAe8souauvCzuwQvOyEKzEXt9+XNZxo91aQpomDmxE9c+HDGwwYSlp8N7nV
	 qX5IIeFUP7ez0sPE1kOaXq+pEUOh0wZPxeooQ8iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>,
	Tatsunosuke Tobita <tatsunosuke.wacom@gmail.com>,
	Ping Cheng <ping.cheng@wacom.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.10 079/123] HID: wacom: Modify pen IDs
Date: Wed,  7 Aug 2024 16:59:58 +0200
Message-ID: <20240807150023.358741502@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>

commit f0d17d696dfce77c9abc830e4ac2d677890a2dad upstream.

The pen ID, 0x80842, was not the correct ID for wacom driver to
treat. The ID was corrected to 0x8842.
Also, 0x4200 was not the expected ID used on any Wacom device.
Therefore, 0x4200 was removed.

Signed-off-by: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
Signed-off-by: Tatsunosuke Tobita <tatsunosuke.wacom@gmail.com>
Fixes: bfdc750c4cb2 ("HID: wacom: add three styli to wacom_intuos_get_tool_type")
Cc: stable@kernel.org #6.2
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Link: https://patch.msgid.link/20240709055729.17158-1-tatsunosuke.wacom@gmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -714,13 +714,12 @@ static int wacom_intuos_get_tool_type(in
 	case 0x8e2: /* IntuosHT2 pen */
 	case 0x022:
 	case 0x200: /* Pro Pen 3 */
-	case 0x04200: /* Pro Pen 3 */
 	case 0x10842: /* MobileStudio Pro Pro Pen slim */
 	case 0x14802: /* Intuos4/5 13HD/24HD Classic Pen */
 	case 0x16802: /* Cintiq 13HD Pro Pen */
 	case 0x18802: /* DTH2242 Pen */
 	case 0x10802: /* Intuos4/5 13HD/24HD General Pen */
-	case 0x80842: /* Intuos Pro and Cintiq Pro 3D Pen */
+	case 0x8842: /* Intuos Pro and Cintiq Pro 3D Pen */
 		tool_type = BTN_TOOL_PEN;
 		break;
 



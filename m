Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C4B3A1C4;
	Wed,  7 Aug 2024 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043700; cv=none; b=J/Job3ivsWNV2633cREx0OgeeB2YMzJ7k2dq/Sn58vIRrIcb9Bt5iUOIG5IqlgzvjR80KkdmCK2KgloMgCVPTzGl6Mhoh0/ryExUHltcfktBynlV8UbJtk7PUqyYKkjql7uoiQH92TeS8ytHFhu9bY666gs423cMFyUcAKtseSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043700; c=relaxed/simple;
	bh=u0+93+csj2Rd1yLTQVZdjItaXxT+9ukMDO6MBA/tU+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddjyzR5vgpamqYgQsi+0UFeAxNeLDwSmZzypNb88qHGzH+8OhGR0WR+grecQ7W1vhD+3jHNvPlCYMFfGg/LTQX+l1pumcyerxGc39ndFMstLrJmo2PLJtN7JJ86/oedEzsNacsNiZ4ivh5NYbS+AKk3tzqWj8zT1T4xbC+cbvjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoVJZWzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoVJZWzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32244C32781;
	Wed,  7 Aug 2024 15:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043700;
	bh=u0+93+csj2Rd1yLTQVZdjItaXxT+9ukMDO6MBA/tU+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoVJZWzDyIIOgHCr1CI3QRYLh8x1y6jCqxnp5Hzx6QG8+ROQ12stJEkkavjDeoJiz
	 trlQggtAk2wBGUwxflxaWrftlJxJbr2VZDgrvaKu9RtfbwvZG/sIMtICfiqNr0cC0W
	 DEXj43tNASNlWSEjIg8YhHFqQ/GmLcCj5lTQc/I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>,
	Tatsunosuke Tobita <tatsunosuke.wacom@gmail.com>,
	Ping Cheng <ping.cheng@wacom.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.1 68/86] HID: wacom: Modify pen IDs
Date: Wed,  7 Aug 2024 17:00:47 +0200
Message-ID: <20240807150041.507068748@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -709,13 +709,12 @@ static int wacom_intuos_get_tool_type(in
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
 



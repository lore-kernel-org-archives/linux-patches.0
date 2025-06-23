Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC9723A9BE;
	Mon, 23 Jun 2025 13:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685118; cv=none; b=jfqHEIhGQqnOGMmXv5pja+6dNrwIeH2i0MWax/XQeeOiTQ94pYcolMhRgewviRAF/8z2xLmf4aaHUAvF73JcjhmOqarMuOYpxMLhlTe63cJYK9Se3V4WjNj+NuPEA83RAjvohjcPlIPGW/iZvIv99C+YTMLCwy0riiVtPkfj9yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685118; c=relaxed/simple;
	bh=J0Xb7TQgtU1jvyUMUY9641wBtpDthUMMJ5A0N298Fjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZSXd+6rjSddISaOtVNTenc2JGFSp+djDyJ+GwdQTo3G6LUHID+1PvyyOh5fYGOH1BG9e97e4PcDzsFwsPaxgXa+WqjtK2FsGqkqdQ97tNu+PDEs+1FJoulLFzvp6Djfx4pZ4KHJPrvaXiOazzZf0q6gOpRpMvoENDHJIdsUio8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhrjDoua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhrjDoua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6F2C4CEEA;
	Mon, 23 Jun 2025 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685118;
	bh=J0Xb7TQgtU1jvyUMUY9641wBtpDthUMMJ5A0N298Fjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhrjDoua+Xgb18mdsIXZdiCbK5P280Fjw6PKZvmwV3MF2HPfKWQbAmeFXf8pFwO9s
	 BDdddL4Ed6c8P7X3KlenGHDalSe4plXymPG0AUOlOy1H6Cuq0uCTvAEZVz6cBsFAAQ
	 yqAvH4+CaGu0/t6VJx/dU3ggfil5UByALIxuxwkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Yeh <charlesyeh522@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 009/411] USB: serial: pl2303: add new chip PL2303GC-Q20 and PL2303GT-2AB
Date: Mon, 23 Jun 2025 15:02:33 +0200
Message-ID: <20250623130633.272094972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Yeh <charlesyeh522@gmail.com>

commit d3a889482bd5abf2bbdc1ec3d2d49575aa160c9c upstream.

Add new bcd (0x905) to support PL2303GT-2AB (TYPE_HXN).
Add new bcd (0x1005) to support PL2303GC-Q20 (TYPE_HXN).

Signed-off-by: Charles Yeh <charlesyeh522@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -457,6 +457,8 @@ static int pl2303_detect_type(struct usb
 		case 0x605:
 		case 0x700:	/* GR */
 		case 0x705:
+		case 0x905:	/* GT-2AB */
+		case 0x1005:	/* GC-Q20 */
 			return TYPE_HXN;
 		}
 		break;



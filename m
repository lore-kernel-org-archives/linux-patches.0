Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFF4225791;
	Mon,  2 Jun 2025 14:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874606; cv=none; b=B+J/NYFoRmFmsZIzq238Icd9GiG4ftozdHFi5DS4XNnzzcUaBrkRxbfhKpmtzdEsLg8SCvDyaShW2K00+dpIVWd1OSLt/gI/i9TSHQq6MzbE3iUloo5Q1e155WfmXGH0qKllsnIo62cD3Qt8i8x+PQ5GVwlLyQ3LLaxF9+LluJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874606; c=relaxed/simple;
	bh=+kLxYBbs8OFlhHwCGdPQn2Joa0FP3jv4KbrAVRwt+70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilCI8IP8TEmexQeOzel1YMzFBNBGy65YM7TbnVr1PjzXRhag4bRTxgGbGDVAaKwchOAKneTfTKUd4Xvh/LsVcE0pI4v/he4hNWuF2lNIXj1eDn59tOPZ0Pna+Dlyu5PH1j4G+aTSRbksv47QscmDY9a8ru1zuUiwpO1deIBg5uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+fjmXbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+fjmXbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21DCC4CEEE;
	Mon,  2 Jun 2025 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874606;
	bh=+kLxYBbs8OFlhHwCGdPQn2Joa0FP3jv4KbrAVRwt+70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+fjmXbHJx+yfcYuz9Fj1csbEObZ9yBVjopoCHqSKTvDodWIico8CCjyVwH6fnaq1
	 39fc+sl3mPnoPMDChzU7FHqzkBWkWy/e/dxA4CFdbgFFo2wDZfiQMQel4Bc2gWyDh0
	 F4uoKJQahGH8Xd7U5RT47nFmEaZ90Qh3dQqurXoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuntao Chi <chotaotao1qaz2wsx@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 038/204] Input: synaptics - enable InterTouch on Dynabook Portege X30L-G
Date: Mon,  2 Jun 2025 15:46:11 +0200
Message-ID: <20250602134257.174363544@linuxfoundation.org>
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

commit 47d768b32e644b56901bb4bbbdb1feb01ea86c85 upstream.

Enable InterTouch mode on Dynabook Portege X30L-G by adding "TOS01f6" to
the list of SMBus-enabled variants.

Reported-by: Xuntao Chi <chotaotao1qaz2wsx@gmail.com>
Tested-by: Xuntao Chi <chotaotao1qaz2wsx@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB959786E4AC797160CDA93012B888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -189,6 +189,7 @@ static const char * const smbus_pnp_ids[
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"TOS01f6", /* Dynabook Portege X30L-G */
 	"TOS0213", /* Dynabook Portege X30-D */
 	NULL
 };



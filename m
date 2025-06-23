Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494DF25392D;
	Mon, 23 Jun 2025 13:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685488; cv=none; b=oES5eKV7q7DVxAvSd/BuzSAju3/P3zqFCeEBg4ECK7uW9D1mjrzflHRugUn8urL8VO88yASbutIgMQuLA0W7qq7yBkcSQoCujPAgtD1jM31KdIHizjDGFjjulPLVd1Zlh92HzCf4m8X1zaQcY3rKTeeNcGKVxSTac9LpiWNzn5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685488; c=relaxed/simple;
	bh=s5yygLUVvs7cAH2XvgpkpLBFS12LL/bABnD2mdkcU8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPL9SIu00f0/gCxmrSWtbh1lZs1eeF7xWrQAsIsUnVIikrfgl6ljZMITTgBXl+F2tzObQcHCTTuQ03PcFkpwN5vI/wya/s8BXXyRn5KTw4/OaDBxffjfGNsHF2sRrwO+him9q2D3EVBPaqbDrLsR6vXhnsLnSqVYCNGksAgfwDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2ggfwRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2ggfwRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A32C4CEEA;
	Mon, 23 Jun 2025 13:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685488;
	bh=s5yygLUVvs7cAH2XvgpkpLBFS12LL/bABnD2mdkcU8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2ggfwRtT6mch4G9EAa3U5M3arV0ypu9jIt+0bgogie19GshbFj4iU9wUo8Ewpy4d
	 eWUsPfUKOSssPWLcwgeIkxYSgVy3Y8usiE1s7FvlHb0PC0Gs47+PYF7NIkAoUYxFc8
	 iuZOZgqsQD0YpTXgvurdD1OLqyzPpV96Z/9AiEL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Yeh <charlesyeh522@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 010/508] USB: serial: pl2303: add new chip PL2303GC-Q20 and PL2303GT-2AB
Date: Mon, 23 Jun 2025 15:00:55 +0200
Message-ID: <20250623130645.507327365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6840031AF3C;
	Tue,  2 Sep 2025 13:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820735; cv=none; b=G55rBGUj/lwq4ME6Wn1WaBBC2RjC78/mX95qzttPjLUpv+fmgjTWSvYjQt+rsXSJLhShsFlieHUVmh+QUlSEJ1VWW9LTb/gIno+5qrfVsiG8XZmrWD1Yct/i3K9mjIvIkQWfv5HUdf5U/H/cn6I5Zdfh+rRsDYBOijbtsbDJE+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820735; c=relaxed/simple;
	bh=MG/HAodlhtlA+SXrvFGfI/c1vLh1bl5sQej+UlSCbxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnp416eoFt006KE/0t2/t8b5Fl8qOFPmy0AmYXjItcZqmqUJHsS3+72aPYtHL4bOFgFXqq5g1epJTrQ3yNrAnPwrt7hDl3+1RHqSXMmLgHTGGGOreniFqHS71veWpMFEhJXjK/EMaGjt/SMjMxjITr6SJwvUgu0nKUI+xV6ZkH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPoTMALI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPoTMALI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E26C4CEED;
	Tue,  2 Sep 2025 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820735;
	bh=MG/HAodlhtlA+SXrvFGfI/c1vLh1bl5sQej+UlSCbxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPoTMALIrtj4gBmz0tmeQFBzSHoxNtXlw3bI/dzqj/Y7iSgL22CaX1Gh4SNYWuPRM
	 fP5MZCj78msdf/hTPsTnPeq5dxopnI2IHwGkI3m1HwURYBzxlTGeNdI3pmR/zYYnb8
	 MzATxm5eZtPVizKGbjAW8h3DRz2mgBcDy7tcQbrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 21/34] HID: wacom: Add a new Art Pen 2
Date: Tue,  2 Sep 2025 15:21:47 +0200
Message-ID: <20250902131927.466548054@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping Cheng <pinglinux@gmail.com>

commit 9fc51941d9e7793da969b2c66e6f8213c5b1237f upstream.

Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -684,6 +684,7 @@ static bool wacom_is_art_pen(int tool_id
 	case 0x885:	/* Intuos3 Marker Pen */
 	case 0x804:	/* Intuos4/5 13HD/24HD Marker Pen */
 	case 0x10804:	/* Intuos4/5 13HD/24HD Art Pen */
+	case 0x204:     /* Art Pen 2 */
 		is_art_pen = true;
 		break;
 	}



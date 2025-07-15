Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62212E424E;
	Tue, 15 Jul 2025 13:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586079; cv=none; b=H5jxkdPJLtNmYh+KTj5iZCJHsvD4y4spqk3JZFb4U1rrygx+XpxBT2gptC8LwuA0fZ4EMhaChpEDKpMlpF6yWIy2EzzbebbIzTKJg/iRhbaPb0jtDgG+IgdcjUkE4Xijqz0NkOWXGdfLKRqNx+RIFRGGAsdy+VjkxOL9PsxQF8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586079; c=relaxed/simple;
	bh=YOag2AKWW/0WiiJuQV1OCN2gGf72JLW+d0f7gOcBrC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkYCSMAk3nlyOjz5TejOJJp4Dz8K1D/Xb6a7mhSQ/Of/08xKIpMpr+25R28JoqrNcX7Jp0EMO29yM580IoesUWXFLOTlS2j40MzSev6odSThp7/LNkJ1wa3vvZ4VP0vfz36owC3i+yQPmT7glNCIDcu1fQTghFxAqV+Kyy3YpIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSkxrOOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSkxrOOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794B5C4CEE3;
	Tue, 15 Jul 2025 13:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586078;
	bh=YOag2AKWW/0WiiJuQV1OCN2gGf72JLW+d0f7gOcBrC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSkxrOOGmtZuRWqFbxssdHaavmK+XrPftuBr9jyYBwFl15lvKA24En5Uv7U3Nh7ri
	 qlMGBn0icosayJWunkkRBq3/9cOD/rkm6T816UzuaqZM+JVqrOBagImcImmYo5PLgH
	 DlcjucN9fFPiWEISa9huNJuVuAnxT7QNurno4Ztc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Wang Hai <wanghai38@huawei.com>
Subject: [PATCH 6.6 105/109] Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID
Date: Tue, 15 Jul 2025 15:14:01 +0200
Message-ID: <20250715130803.083351454@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 9cf6e24c9fbf17e52de9fff07f12be7565ea6d61 upstream.

After commit 936e4d49ecbc ("Input: atkbd - skip ATKBD_CMD_GETID in
translated mode") not only the getid command is skipped, but also
the de-activating of the keyboard at the end of atkbd_probe(), potentially
re-introducing the problem fixed by commit be2d7e4233a4 ("Input: atkbd -
fix multi-byte scancode handling on reconnect").

Make sure multi-byte scancode handling on reconnect is still handled
correctly by not skipping the atkbd_deactivate() call.

Fixes: 936e4d49ecbc ("Input: atkbd - skip ATKBD_CMD_GETID in translated mode")
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240126160724.13278-3-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -826,7 +826,7 @@ static int atkbd_probe(struct atkbd *atk
 
 	if (atkbd_skip_getid(atkbd)) {
 		atkbd->id = 0xab83;
-		return 0;
+		goto deactivate_kbd;
 	}
 
 /*
@@ -863,6 +863,7 @@ static int atkbd_probe(struct atkbd *atk
 		return -1;
 	}
 
+deactivate_kbd:
 /*
  * Make sure nothing is coming from the keyboard and disturbs our
  * internal state.



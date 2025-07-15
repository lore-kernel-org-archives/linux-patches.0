Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E172E5B06;
	Tue, 15 Jul 2025 13:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586253; cv=none; b=gDQ52OTQESpHGHII053mpSkmbQgq4p9JNS++vv0UnpPs5rvgBe8kaRt9Bu0KdypPqcIFjJRMaEB39J+LW3DY8DTVyMCaulhWYzKjr8pF0k/O34P4ZwQzRlOPKdL/WUrRxSlzDCht66p3qxi+UMa0RTfpM72aEfwQYExcet4U72E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586253; c=relaxed/simple;
	bh=sSTDWX/gzuo9ErBsCsXnbRgDCXUQjzjjS5MOXmLAJQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKFsRzBXQn7eCsiLL2f8siRz9yg0PD9FvG4j8vI0dlzEgJPqLv1y539Keiu105/UfOhbo6sLPgDK03pZTc7mjK3nGJmHKWVKmk2ueG/iEyD8FpNZlx4O5q+8aUBGhQrPQI+oje/BmPXnZ6V5BGjXR8qhHK2NcmeOr9QPVA8/dXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzTSBqTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzTSBqTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764CAC4CEE3;
	Tue, 15 Jul 2025 13:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586252;
	bh=sSTDWX/gzuo9ErBsCsXnbRgDCXUQjzjjS5MOXmLAJQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzTSBqTpXnK61ZIw1clVAmoBVwYv8PAe7dV8fOTdq16IdDO8W6jUFDt1jWNQxnCd2
	 OeJoN0jZdUzA6tQ1agZcmtNBjpLaW09lg7MGxPkoPRenTdCbqkj+Hp8NYp/ICx61uj
	 2tP7kY5UYy1RGU0FCQAC+gqT0aa8L3lAp8Im1hBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Wang Hai <wanghai38@huawei.com>
Subject: [PATCH 5.15 74/77] Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID
Date: Tue, 15 Jul 2025 15:14:13 +0200
Message-ID: <20250715130754.695992312@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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
@@ -817,7 +817,7 @@ static int atkbd_probe(struct atkbd *atk
 
 	if (atkbd_skip_getid(atkbd)) {
 		atkbd->id = 0xab83;
-		return 0;
+		goto deactivate_kbd;
 	}
 
 /*
@@ -854,6 +854,7 @@ static int atkbd_probe(struct atkbd *atk
 		return -1;
 	}
 
+deactivate_kbd:
 /*
  * Make sure nothing is coming from the keyboard and disturbs our
  * internal state.



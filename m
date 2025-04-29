Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B6D2AE96;
	Tue, 29 Apr 2025 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949916; cv=none; b=udRHn52CuzA1KiQYKchdrTnMPk2gX+zALt2rR6TJPOPM8E5XdYu6SQMaNsom43TjcO0mDZmFViX1zgpAJgud1e9GEdr6OR2Z5Qau76Y6kwo9PJpqaBTId/4StO0JHpNuOrjK6oXbp3NidcUYiVjfBo1rya/MBmMech7fMRnsdx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949916; c=relaxed/simple;
	bh=6aJlFYi0n1hgC+wdu+I0R2DZP1O+71PHB/3U+Byqx/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlmikwTjp0E7l54Lh8/qQoJ3gkR9ylC+FQba7NqvvnuGubTCR2NigYffY4k+AZsMo67FnNZXhayAHAeNkNktn6AoJJZgI8EOrD3V3QqxAfvuMzELRHygNI+hZescDj5D6FLlYDzG5/ttL0nsNYo3wl9eklt5yr3F28OPW0dtFD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLYr0fte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLYr0fte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC30CC4CEE3;
	Tue, 29 Apr 2025 18:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949916;
	bh=6aJlFYi0n1hgC+wdu+I0R2DZP1O+71PHB/3U+Byqx/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLYr0fteOfY5qJVurw7NIRqfocd1C0sxxGpK+b7cCulRK/c8Pg/qodn56mzahfr9s
	 8dq/bndQ3h/k90KVotk6xCb7RTgfqUWviWccasgC68AQ4CMGHCEXovM9K8OygHHpbK
	 vCN7yh/4D9LwN0Mt3n+h4M89fW2LQ2RNt2dqHVAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 090/167] usb: quirks: add DELAY_INIT quirk for Silicon Motion Flash Drive
Date: Tue, 29 Apr 2025 18:43:18 +0200
Message-ID: <20250429161055.393201644@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

From: Miao Li <limiao@kylinos.cn>

commit 2932b6b547ec36ad2ed60fbf2117c0e46bb7d40a upstream.

Silicon Motion Flash Drive connects to Huawei hisi platforms and
performs a system reboot test for two thousand circles, it will
randomly work incorrectly on boot, set DELAY_INIT quirk can workaround
this issue.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250401023027.44894-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -383,6 +383,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0904, 0x6103), .driver_info =
 			USB_QUIRK_LINEAR_FRAME_INTR_BINTERVAL },
 
+	/* Silicon Motion Flash Drive */
+	{ USB_DEVICE(0x090c, 0x1000), .driver_info = USB_QUIRK_DELAY_INIT },
+
 	/* Sound Devices USBPre2 */
 	{ USB_DEVICE(0x0926, 0x0202), .driver_info =
 			USB_QUIRK_ENDPOINT_IGNORE },



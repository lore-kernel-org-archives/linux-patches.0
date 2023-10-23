Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF8214A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfGXBaiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7DBC433C8;
	Mon, 23 Oct 2023 11:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059035;
	bh=pAdG5+Gn4vIj5XyQYkxrnWO4cT+XsKsGHEu2iOtHiMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfGXBaiR+cfT+GPSowMDz+VNYwPPf/I7MgNzMzG4rwik09uTcUBZkho3+P20uZ+3G
	 JiUtcQre3x6ZQbYWckvWCeqZ5R/Ag5bMIvbDBRkQFqJVxyq2sxjoHMj/lIFHd7oPy+
	 6L55+/CH0OTuP5uUjvmdVxZRJart43hJpzBg0BKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>
Subject: [PATCH 6.5 042/241] drm/edid: add 8 bpc quirk to the BenQ GW2765
Date: Mon, 23 Oct 2023 12:53:48 +0200
Message-ID: <20231023104834.943643237@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit 88630e91f12677848c0c4a5790ec0d691f8859fa upstream.

The BenQ GW2765 reports that it supports higher (> 8) bpc modes, but
when trying to set them we end up with a black screen. So, limit it to 8
bpc modes.

Cc: stable@vger.kernel.org # 6.5+
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2610
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231012184927.133137-1-hamza.mahfooz@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 340da8257b51..4b71040ae5be 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -123,6 +123,9 @@ static const struct edid_quirk {
 	/* AEO model 0 reports 8 bpc, but is a 6 bpc panel */
 	EDID_QUIRK('A', 'E', 'O', 0, EDID_QUIRK_FORCE_6BPC),
 
+	/* BenQ GW2765 */
+	EDID_QUIRK('B', 'N', 'Q', 0x78d6, EDID_QUIRK_FORCE_8BPC),
+
 	/* BOE model on HP Pavilion 15-n233sl reports 8 bpc, but is a 6 bpc panel */
 	EDID_QUIRK('B', 'O', 'E', 0x78b, EDID_QUIRK_FORCE_6BPC),
 
-- 
2.42.0




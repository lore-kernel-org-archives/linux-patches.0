Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396CB29CA;
	Mon, 12 Aug 2024 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479610; cv=none; b=s1q/Gvru9AsZwfvZ+pw6uS4L3rBW/GTfUKgZGrVuf1HPqV1VPao5NIPv56BKTFVtpbXGa8MTZb+0T9bovRY92BhvoCZzVWOIbxhigMfoucuDlYJs5cFf5eezUe1t0vWgyKu7VpUM4ConyEGWXQFYSxaIzFDuXXsAZXiIVjCQsLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479610; c=relaxed/simple;
	bh=wWo+FqzFZ2CYj+H6YYj6kkjsYQ/oO3/n1CWPVGF8Fzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7dVVZPn52cmfZxo8fDSHlnJRb5omnFjH2dXx6yNKMpwKn62fwIyE6CIuOzjhcHjCUFzAl0PXKiizmx2JmG+sTuEGfDmVC4/8lIe8vxYYJd/suPLjPaN4OJcErEXCxFsRVkUihLBqogD+CzVdXmW33uynJ0kymW0Jqx0fv5EzAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqDXZytr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqDXZytr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32DBC4AF09;
	Mon, 12 Aug 2024 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479610;
	bh=wWo+FqzFZ2CYj+H6YYj6kkjsYQ/oO3/n1CWPVGF8Fzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqDXZytrRdvB0+4bfNWfsnUVtePbbzl0lZk5ZiM6sPoE8vxe93xeIiVsbRkNgXX/L
	 fQ0SvSphSUuNkA37tn1xChwDxdMDQzbAc/iIasLE74aQde021AMYdFj7PX8s1m4lAY
	 m405F6ikqe9xw5XimvtCcBKmsGQsG/2aE4lhji6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 140/189] ASoC: amd: yc: Add quirk entry for OMEN by HP Gaming Laptop 16-n0xxx
Date: Mon, 12 Aug 2024 18:03:16 +0200
Message-ID: <20240812160137.530150571@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6675e76a5c441b52b1b983ebb714122087020ebe upstream.

Fix the missing mic on OMEN by HP Gaming Laptop 16-n0xxx by adding the
quirk entry with the board ID 8A44.

Cc: stable@vger.kernel.org
Link: https://bugzilla.suse.com/show_bug.cgi?id=1227182
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20240807170249.16490-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -413,6 +413,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A44"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
 			DMI_MATCH(DMI_BOARD_NAME, "8A22"),
 		}
 	},



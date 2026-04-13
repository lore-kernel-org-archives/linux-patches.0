Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38571238D27;
	Mon, 13 Apr 2026 16:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097940; cv=none; b=N74WjX+IegkkumpNJaHj0yuUhrL6jHVISj9sSLx/dXFXKKqvIlGR0LF5eg12XuynW0R0X3DohovotngqWqPGLrQjc5ZXhZXQ6wA667kQsg4uFIIZpX6PciD9JpvVsh068FrQCoBto+mrqUsWXChMCGdLb6nGxb+xHyfFKi9GHTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097940; c=relaxed/simple;
	bh=rlbAQZ0OvzQcak6ttHdV35YclqqmYVA9YSUmpaJCLz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rX9hem4bjT6c7oq1I3RavhzF1ZLoLLmbmJAyDWLBUbpluenFjQhOVkO5Ju0i8vG/SbSmTz0v4W3/YthWErHdWqo0Dx/CsyzxN1eNAAoEmJrwSolNxGetBOUF0kucFyAIHx8gHGWFlAlhLKbtA97CcC5ryFL/DVES4O08nS6hzac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRzBXrlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRzBXrlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24D5C2BCAF;
	Mon, 13 Apr 2026 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097940;
	bh=rlbAQZ0OvzQcak6ttHdV35YclqqmYVA9YSUmpaJCLz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRzBXrlf460/l9gR7IMhxBXvyeH9Alr6h7/Aes9Q0CSWvB2+OXS5vr+YP8cwyk+Od
	 4Xaqnd05T7JJir7lAnpaQRPvtu5F9TV94VqzfKylPVBDcYSzdjS9YZhI9NehVKIXw6
	 KNE64sDCPYlnbiyQTd2poZk2CDpWAss23yPrgDh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leif Skunberg <diamondback@cohunt.app>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 300/570] platform/x86: intel-hid: Enable 5-button array on ThinkPad X1 Fold 16 Gen 1
Date: Mon, 13 Apr 2026 17:57:11 +0200
Message-ID: <20260413155841.738933215@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leif Skunberg <diamondback@cohunt.app>

[ Upstream commit b38d478dad79e61e8a65931021bdfd7a71741212 ]

The Lenovo ThinkPad X1 Fold 16 Gen 1 has physical volume up/down
buttons that are handled through the intel-hid 5-button array
interface. The firmware does not advertise 5-button array support via
HEBC, so the driver relies on a DMI allowlist to enable it.

Add the ThinkPad X1 Fold 16 Gen 1 to the button_array_table so the
volume buttons work out of the box.

Signed-off-by: Leif Skunberg <diamondback@cohunt.app>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260210085625.34380-1-diamondback@cohunt.app
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 6331469ee6585..cbc4ec2f8479b 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -102,6 +102,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Tablet Gen 2"),
 		},
 	},
+	{
+		.ident = "Lenovo ThinkPad X1 Fold 16 Gen 1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Fold 16 Gen 1"),
+		},
+	},
 	{
 		.ident = "Microsoft Surface Go 3",
 		.matches = {
-- 
2.51.0




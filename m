Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EB41420B3;
	Tue, 27 Feb 2024 14:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044112; cv=none; b=p0olIf+GqaIJcZQWoV6+zDjuoqfEt6kRm9RsVx5HhUrNj4VubRVdN1i24KttJem+vPhYN8XCmJOZA1tT+bMiYqjBJRzHxxXxG8MfnGkUbdvQYC382OPx2HJMaIZW9hQlin1jqfZX+bhYMqk764MfqWyc1XjnDjRBWx75QtkUbPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044112; c=relaxed/simple;
	bh=RkEHuy/e9Srrmd/hreLKmD3hHavnMbvffmVqqKSmFaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHVTMtrWrlC4zY66TkeHylBKnxtcP/6IkN7iPxD1qLu6OijVLp/twdMysri5QCQKWkYTY+jyGD4LJeFSo+2dmPGNhaAmZeSU9COrhNfrW07OLkoiE1KR1xCUBO5cDwVJru27TtG/ROS3J6tUPzZykVaE2mRI5K7xpkrMPwgh0yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rciT1GOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rciT1GOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEACC433C7;
	Tue, 27 Feb 2024 14:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044111;
	bh=RkEHuy/e9Srrmd/hreLKmD3hHavnMbvffmVqqKSmFaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rciT1GOr7egzQcWk2zyAJeT0rI/qxOPLeA1VrPpqhyGT3vTI++YS1t9OLa79h2t0G
	 hhCYFpRU4gvkQbVM7Kf7gzyeSSsOK0TPeX9KRbIXL1NBVbra/qwRMD9ApttCmtrjjP
	 SKN3V8mYa+mLMEqP3YzibgqChCJg4pTIgRcuUenQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Verevkin <me@maxverevkin.tk>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/122] platform/x86: intel-vbtn: Support for tablet mode on HP Pavilion 13 x360 PC
Date: Tue, 27 Feb 2024 14:27:07 +0100
Message-ID: <20240227131600.862693048@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Verevkin <me@maxverevkin.tk>

[ Upstream commit 07b211992d6c0d80b321403244d43bbd2d6cf48c ]

The Pavilion 13 x360 PC has a chassis-type which does not indicate it is
a convertible, while it is actually a convertible. Add it to the
dmi_switches_allow_list.

Signed-off-by: Max Verevkin <me@maxverevkin.tk>
Link: https://lore.kernel.org/r/20201124131652.11165-1-me@maxverevkin.tk
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index a90c32d072da3..9c8a6722f115e 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -230,6 +230,12 @@ static const struct dmi_system_id dmi_switches_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 7352"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion 13 x360 PC"),
+		},
+	},
 	{} /* Array terminator */
 };
 
-- 
2.43.0




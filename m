Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567804B1B54;
	Mon, 31 Aug 2026 13:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184257; cv=none; b=od4hfEGvdW+iZIbBLpU99H5RT2OjspAIO2/PdouxzfAUyWosrnyq8ViPodAUdX7rBn5uDMTdxOLtda81InD/gt2dNtJiXqmbrmPkrg95h0dNO63PBAXg7+Sseof+JNerKaxVZNqvWY+1A78WZ+gOg/SS28mYpUOO6GhLHrqNxhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184257; c=relaxed/simple;
	bh=fD/sOHgogF5Gm8YOeuSS2DIXt3eloanhGTadJ7ezX+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igAXmaioNDsABPRlNg5o8+9jGpm2oTm3axS/F41YOV4A5uc18qPlMOuYaLvJsOAbbmGo1Ds6UPAQ1RNqfDzyKpHwRUo5i++9+UFeTZu2nBKEF5qQ6omUFOh9AEz8FoObmi1rMRorWZPIfkvLccYs5fBEFkmyqBa+lXK0A4o9Bxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DR0HJdxi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DR0HJdxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8231F00ACA;
	Mon, 31 Aug 2026 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184256;
	bh=qsSF4ESMb7yDlbB+B/JiYFlsOBA2zt+5DnbNcTE/feI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DR0HJdxiu5i/8edim8rm5HLUVhNrp3LiM6dGamLWweG3KyrosCjmifJe9x3LCRd+U
	 sLMoTj2B1uws9z/oKmjidySCDaqdQxwYRRVaLoh5azNZlp645WvQVmoS/Y/AJiFFAl
	 vd651be08kFZZmUk4PwOFobpoMZ4FC76PxSNIWkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 44/99] HID: pidff: Rework pidff_set_time() to fix warnings
Date: Mon, 31 Aug 2026 15:34:13 +0200
Message-ID: <20260831133402.212641760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit bed72bd240ce77623845853397b89a08f6dc5770 ]

Fixes blank line warning from checkpatch.pl script

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 67bb1074e3d2 ("HID: pidff: fix OOB write when hid->inputs is empty")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -339,8 +339,8 @@ static void pidff_set_signed(struct pidf
 
 static void pidff_set_time(struct pidff_usage *usage, u16 time)
 {
-	u32 modified_time = pidff_rescale_time(time, usage->field);
-	usage->value[0] = pidff_clamp(modified_time, usage->field);
+	usage->value[0] = pidff_clamp(
+		pidff_rescale_time(time, usage->field), usage->field);
 }
 
 static void pidff_set_duration(struct pidff_usage *usage, u16 duration)



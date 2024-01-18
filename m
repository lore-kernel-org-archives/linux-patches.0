Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2C21774B;
	Thu, 18 Jan 2024 10:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575427; cv=none; b=VjuR/0pHMZCQZIAHEQFpOqt6IcfEHrufB3v8H009QiMclOiBeVqyZvMZtQURxUNIak5Qjgl1KGfxPjmQ78dj7+K+INZtN0wUYjTsQcP+LgScLoyHotUd1iFnVxsVIWQ6fZ+4Gd/3VODhYzhpGgNJFkedsbenOT1VYWkGgSzU+nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575427; c=relaxed/simple;
	bh=A+bWdW988fU2Lg07vq5WD043ijfsoCJBLYY1s804QIo=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=V6RHIOPs0OLMmIYIo7lgzNWjjX2j2HhiZh0cHDZYOjKo0zA/zrdzy0/ih2Dfgo7DGGXoXBAh5HzmFAbq2JtudW27OgACJ8Pb7HyG/foCJK4PXlJO6FaQu56ZN7SGZhMY6IfnECs1zo8yWeQ3xnfk1FYmQwvQ9GmHB+6fovi84XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/tJXxwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/tJXxwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE3BC433C7;
	Thu, 18 Jan 2024 10:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575427;
	bh=A+bWdW988fU2Lg07vq5WD043ijfsoCJBLYY1s804QIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/tJXxwN46ujwA/fmY2j2Tf6bGkQumpwNYtO5biRNkKvI2STQxPqNW4wi7mtqCwif
	 KUIiDtAwcrveZIiVcoZk9f7J8nX7m4LXQ8C1wlW9olqxNI9kDse+oL79PvwDilS3WD
	 y0IO8Y495P0dtC32QF9DTN6QXAVSgR3Dh1kXBl2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/150] kselftest: alsa: fixed a print formatting warning
Date: Thu, 18 Jan 2024 11:48:41 +0100
Message-ID: <20240118104324.536641492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>

[ Upstream commit 13d605e32e4cfdedcecdf3d98d21710ffe887708 ]

A statement used %d print formatter where %s should have
been used. The same has been fixed in this commit.

Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Link: 5aaf9efffc57 ("kselftest: alsa: Add simplistic test for ALSA mixer controls kselftest")
Link: https://lore.kernel.org/r/20231217080019.1063476-1-ghanshyam1898@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/mixer-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/alsa/mixer-test.c b/tools/testing/selftests/alsa/mixer-test.c
index 21e482b23f50..23df154fcdd7 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -138,7 +138,7 @@ static void find_controls(void)
 			err = snd_ctl_elem_info(card_data->handle,
 						ctl_data->info);
 			if (err < 0) {
-				ksft_print_msg("%s getting info for %d\n",
+				ksft_print_msg("%s getting info for %s\n",
 					       snd_strerror(err),
 					       ctl_data->name);
 			}
-- 
2.43.0




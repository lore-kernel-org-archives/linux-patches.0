Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BB71FBC90;
	Mon,  2 Jun 2025 14:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874294; cv=none; b=mqlE9ahPJqyPGM/TnQ5z0XNH3XfAWCtuvrjbgvr2p3Z3iPYGjiJgXkPodT9a8mRpFxi+4ohPZAVnaVEkDulIrf5PbWni7mGqu1vWi33MJK3xMh1mAYXNpZsllX6PyBh7z+aEjY3mW61DriFf2lACR3v+7lKE0ZQife/kRNewguc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874294; c=relaxed/simple;
	bh=Kiy/mEwRwrbIJnYyHDRMlN17f5t0/EV8GOiBGmU5Gqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGIiuXrL3/YhdXK9TLH5kmPdcs8Hu0kSUKLXaOFRozQylYlpTlH4+OlwfXKQlX87ZcQy2PBwB4DkpFa6iTJax0lqt6uQZqngO9iGa8D5EKiDEbgJZa3Ygnonz1mzTZTSHt2nlDqOO7eO7hiPHgzoB39M4iXMWbfrzMKWhBYzaG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WW+pz6zo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WW+pz6zo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68179C4CEEB;
	Mon,  2 Jun 2025 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874294;
	bh=Kiy/mEwRwrbIJnYyHDRMlN17f5t0/EV8GOiBGmU5Gqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW+pz6zoM3MT3t6121xxE7MDdKBUQaoZ29uVumcR5EPC0c2/Um/At0XcAlZ8tSNzm
	 N5cTTgONRD0yE7vyu/f1+ONfP8oNfYA0mqhx2dFb0FWRYSZandFv7QZTfFctNtig4Y
	 ejsAVWvksw0YrixwFovf4e9IV0eQMeaydqiTZqPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 422/444] arm64: dts: qcom: sm8350: Fix typo in pil_camera_mem node
Date: Mon,  2 Jun 2025 15:48:06 +0200
Message-ID: <20250602134358.072195264@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

commit 295217420a44403a33c30f99d8337fe7b07eb02b upstream.

There is a typo in sm8350.dts where the node label
mmeory@85200000 should be memory@85200000.
This patch corrects the typo for clarity and consistency.

Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://lore.kernel.org/r/20250514114656.2307828-1-alok.a.tiwari@oracle.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -442,7 +442,7 @@
 			no-map;
 		};
 
-		pil_camera_mem: mmeory@85200000 {
+		pil_camera_mem: memory@85200000 {
 			reg = <0x0 0x85200000 0x0 0x500000>;
 			no-map;
 		};



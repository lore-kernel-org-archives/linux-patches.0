Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40B62576;
	Mon,  2 Jun 2025 13:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872681; cv=none; b=m8MnRQrZVUPSuBOHM5tGtJs/FkARd4OophiNpQ+NzJXxb+wkQErEP+u9TyOWuYBR1sZtCnecxy2D/hnx8WHXo+CNWlPe+u5zxBYIJrl8+Aq7B7JKaCwE1NNoXXtYt4xGc0VI1YZKqNvBfkAa+sla3df1cT+hkETCSphIgZ5YfnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872681; c=relaxed/simple;
	bh=iEJlTnW0gTvw519vxXh7c/ctqYukAxAYMdCo0fAWD5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsNT50iSX/eW8WZJoVu02UowReWO4FIt7UdKyY3d6mFgzVHx+5tIg6gGU2fP7FDZzib6N70rAn7gOeE4ZR5+lHFwnLxfTgvtuhHzyjPhqy3cRHpYD6LRWkaI+eB2oESUhldvYLrDk8JRTmDXfrMKYWjqsnX6Hc0kme3UsHp4xnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p93TQNTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p93TQNTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1A0C4CEF0;
	Mon,  2 Jun 2025 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872681;
	bh=iEJlTnW0gTvw519vxXh7c/ctqYukAxAYMdCo0fAWD5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p93TQNTexERMnZZ5zfYbVE1EGeIsw2PTljA+YwTr2n/SUGx3Drl2SNEK5HzwCWa6x
	 wEGYpHtX4y8A5EeKEwWmcyXbNGaDjm4dMJlLyfaucRKw5WPuvnuNJQV3fd3qP3awlY
	 +oW67oGzj1Msg2m9xg2lH3ZeqKJqR+GdxOr3jG4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 08/73] arm64: dts: qcom: sm8350: Fix typo in pil_camera_mem node
Date: Mon,  2 Jun 2025 15:46:54 +0200
Message-ID: <20250602134242.006891256@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -455,7 +455,7 @@
 			no-map;
 		};
 
-		pil_camera_mem: mmeory@85200000 {
+		pil_camera_mem: memory@85200000 {
 			reg = <0x0 0x85200000 0x0 0x500000>;
 			no-map;
 		};



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029644;
	b=hN+q+qdwCZT6eU0O+yprMKh/uuG3lXJgwLCmvB+d3Y/5mUMnAPK5dKug4ccx8OaSKqIC
	 u4ce9kPIM8Ft6UTS6oYjxTRxMMTs+L+cV/nEiyQLIy3ONxxCRzrh+t7CTw2IE0K1QmOi+
	 /X6t/snXKbR6MxRJW+4OeFAznMNn5QuxgC35dWWyB0Z0Nc9W/K1KVgtncIhCFH4OuiRqK
	 L5DgfdEhoAKoKw7M2kgaSiNId/zqC/tHnY6IF2GrjrjOfliUbNv6NmZhj5rEzHZWkPSg1
	 ZtJ2eYIYz5iELEE9XJ8mC60OOKCHE9B8seuVuRfNDUE/e1SXbfHJBVas3twiN+5YU2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NoCnrn0Rrx5y+bSVrHu4yA5oxVKQB6K0oHIqnJEsp5s=;
	b=zavb2fV6e61PMhuEaKIKzGgINcXwDH5SfvfpIJjtaHTVegLHZdsNi3gSZcZ8EeYsioM4
	 peM2bHOQOSGW9bWMNHbt1Dxbmvc+wO27Em/iyoah2NnMJXrMwE4OutRUhDjpEEdr3jjMW
	 ZNPbh+tTVcdTvJBag1Z8dAQrynsXcurajFwkTnsdbN8PhJ8q5TWG33AyUMujYsjuAD9Qs
	 XyMcAsUfUTK2hTdoAKP0mFgesTlKFjvPDxvH+UavzA38OhVHkR59B02RIu8OubpWPLgdN
	 sL83yx4kWcWT4z/688N4hv1c5WdsmJ32667hgPXJQYYS6xJj44+3PUXdpax88+MZdSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kgb64iCq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE90606A31C;
	Wed, 18 Nov 2026 19:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kgb64iCq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7501C1F000C4;
	Wed, 18 Nov 2026 19:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029644;
	bh=NoCnrn0Rrx5y+bSVrHu4yA5oxVKQB6K0oHIqnJEsp5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgb64iCqRpx4rBUSkkPYSrRaJCGpC2PKKyU324IeP+D5lILXTSeNkM77neWsloBYS
	 VngTslEZpk2stYQH/ybJQkgbBalkaKFq+FDFmxuUVb0nLH8MiaAauz+R4uZB0TvBzo
	 qSpfBSygxkE94rUv+S2d5AQkd4oNDBWBgdStWatI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0378/1756] clk: rs9: Add clock index range check to rs9_of_clk_get()
Date: Wed, 18 Nov 2026 15:41:45 +0100
Message-ID: <20261118150023.520223153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a2ef401bdfd19aa41d0e3e1b630a12fbc01ac184 ]

rs9_of_clk_get() does not validate the clock index in the passed
DT clock specifier.  If DT specifies an incorrect and out-of-range
index, this will access memory beyond the end of the clk_dif[] array.

Fix by this adding a range check to rs9_of_clk_get().

Fixes: 892e0ddea1aa6f70 ("clk: rs9: Add Renesas 9-series PCIe clock generator driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-renesas-pcie.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/clk-renesas-pcie.c b/drivers/clk/clk-renesas-pcie.c
index f94a9c4d0b670..6650e3440c749 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -277,6 +277,11 @@ rs9_of_clk_get(struct of_phandle_args *clkspec, void *data)
 	struct rs9_driver_data *rs9 = data;
 	unsigned int idx = clkspec->args[0];
 
+	if (idx >= rs9->chip_info->num_clks) {
+		pr_err("%s: Invalid clock index %u\n", __func__, idx);
+		return ERR_PTR(-EINVAL);
+	}
+
 	return rs9->clk_dif[idx];
 }
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DE7221FBE;
	Mon, 23 Jun 2025 21:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715152; cv=none; b=bZJeRj2e9DiWIF4eO+CwzHzuJYFyS3e/WKi2gV0wMEwlrmqul/fsB/lNhMskZJ4DwI1JI5L+fNtTJBSpStvxqsdoQsKnSnDLcJI4bzaYVzTW41OuZt56PyCeeqx/ZM5Bh74I0rms7/bhh8UHB/XbhPrhQXY0avTse0SAS/GRXfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715152; c=relaxed/simple;
	bh=VU5EBAqcrpRBVGS/iNd+rTUhbOxJSJiZn8nlVFy5tGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeWJYAKHN9gzKHo/nnVxmkouefvRQif2luc1zk06ABwBDbmRKhcanuuXKkyX9nv/VRe+heMt4PUY8aa2Wyjc7oSLOsMHFjbXt6gnZE8vfBg1JCtBWSQ9aNWwskK7AdcQ8sCR0WSfysIpN2TCFoqVRnx6fGG13FAbJgWXjfGA+qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wikFzdgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wikFzdgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D8BC4CEEA;
	Mon, 23 Jun 2025 21:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715151;
	bh=VU5EBAqcrpRBVGS/iNd+rTUhbOxJSJiZn8nlVFy5tGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wikFzdgPUgPcN49P7UDtts7Z2Jmr/YbYcW6oCAcc2J3YrR6RYXu026BNW436JLdnk
	 zWVfK3tPOHP3azl5G5RuQLnx7zeGreBlFmI6JRZWhWJMZD5p99O+8qciz2eb5eHTdb
	 ui59oRZvrfnmKYXfrMvtWHYVueay0NOVqefGtN4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Da Xue <da@libre.computer>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH 5.15 239/411] clk: meson-g12a: add missing fclk_div2 to spicc
Date: Mon, 23 Jun 2025 15:06:23 +0200
Message-ID: <20250623130639.672031691@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Da Xue <da@libre.computer>

commit daf004f87c3520c414992893e2eadd5db5f86a5a upstream.

SPICC is missing fclk_div2, which means fclk_div5 and fclk_div7 indexes
are wrong on this clock. This causes the spicc module to output sclk at
2.5x the expected rate when clock index 3 is picked.

Adding the missing fclk_div2 resolves this.

[jbrunet: amended commit description]
Fixes: a18c8e0b7697 ("clk: meson: g12a: add support for the SPICC SCLK Source clocks")
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Da Xue <da@libre.computer>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250512142617.2175291-1-da@libre.computer
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/meson/g12a.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -3969,6 +3969,7 @@ static const struct clk_parent_data spic
 	{ .hw = &g12a_clk81.hw },
 	{ .hw = &g12a_fclk_div4.hw },
 	{ .hw = &g12a_fclk_div3.hw },
+	{ .hw = &g12a_fclk_div2.hw },
 	{ .hw = &g12a_fclk_div5.hw },
 	{ .hw = &g12a_fclk_div7.hw },
 };



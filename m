Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71DD3570D9;
	Tue, 16 Dec 2025 12:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886552; cv=none; b=m45YGMKmf10scLN90v163UBqzKGA4iafrlLfkRlZtwrL4MYdZys2UbA9i7QtsKafIrcYMK2aYmC3rgvFcjvvBqR8lBQvc2HXvRjuxTQokQJ3Xdf11zq5XLmFKbE61q7pMYmnVvCL91edP5gmImQLdpWPqKGXqWdToaXekM/DVjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886552; c=relaxed/simple;
	bh=WuxkaZ5BcBBJwuvPAdGpj4CQeaiRPOT1zH3kEwwvOgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LctJvkmcFeMsMZCjFMguusXzE1/7KkDq7uoTVQct1hTIqhdLc+pD46mTl12B3IsRJL9p0G9fKG9ANlbueQ6lYzuzeuhA5YdD7TX2n0bmEgb6chmubpWAh7n3Q9WRnRmUpCBAR6N7Yz8hjnKhxZONPZBiU/knShZsGuw6hGkSG84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AR7IpqG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AR7IpqG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1900FC4CEF1;
	Tue, 16 Dec 2025 12:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886552;
	bh=WuxkaZ5BcBBJwuvPAdGpj4CQeaiRPOT1zH3kEwwvOgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AR7IpqG5uS38zDo69Cs9oFQBPNLFSziOiKGfDReSy9qn3w03fRhdP9pKG8Zb08677
	 gydJj1udzL0gYO8x0c+597VAgTBk1RnQCQEXqqxtHutBmPc2r8jdSSlVe5jvSM4L0k
	 bk7KxT7MQqxjuwZdJdg6CXQ99bjykgo4Q5Gc5+wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathara Sasikumar <katharasasikumar007@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 471/507] docs: hwmon: fix link to g762 devicetree binding
Date: Tue, 16 Dec 2025 12:15:12 +0100
Message-ID: <20251216111402.508253360@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathara Sasikumar <katharasasikumar007@gmail.com>

[ Upstream commit 08bfcf4ff9d39228150a757803fc02dffce84ab0 ]

The devicetree binding for g762 was converted to YAML to match vendor
prefix conventions. Update the reference accordingly.

Signed-off-by: Kathara Sasikumar <katharasasikumar007@gmail.com>
Link: https://lore.kernel.org/r/20251205215835.783273-1-katharasasikumar007@gmail.com
Fixes: 3d8e25372417 ("dt-bindings: hwmon: g762: Convert to yaml schema")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/g762.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/hwmon/g762.rst b/Documentation/hwmon/g762.rst
index 0371b3365c48c..f224552a2d3cc 100644
--- a/Documentation/hwmon/g762.rst
+++ b/Documentation/hwmon/g762.rst
@@ -17,7 +17,7 @@ done via a userland daemon like fancontrol.
 Note that those entries do not provide ways to setup the specific
 hardware characteristics of the system (reference clock, pulses per
 fan revolution, ...); Those can be modified via devicetree bindings
-documented in Documentation/devicetree/bindings/hwmon/g762.txt or
+documented in Documentation/devicetree/bindings/hwmon/gmt,g762.yaml or
 using a specific platform_data structure in board initialization
 file (see include/linux/platform_data/g762.h).
 
-- 
2.51.0




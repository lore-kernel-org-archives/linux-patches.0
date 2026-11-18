Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049025;
	b=2JGeNu9JaPBnFQROOeB0TnLTfyS1qrgAiBqEpB9ATtGaE7H712TFk4ew18KEkuAWeokl
	 kmg+EeL/UWR7xVTJQomXzSoJq5e2asMfBGEiNClz9wCIvXbNlOyLDt337Hf7tWsRZjifn
	 ooFo8d7aciWvACI6FYqsXOZLY1Gbh9LEArYXOAqI1w800SU1F47wo2SZmcW1IQl+1ZB2f
	 7BHEAfxwklwjZNWSUzXIY0mf80LzSiSlIi2Ava5JSSUZSh7QKIyXstlfKeTouD0t2lr+4
	 Nby1WwyXP0UXUuMso/nnSEbQBWk5mylxcrs/K36jd1e2Ld1aDSrAzKw77Mx+eOMtIcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oLwMI8UquJ3AvbLOKSqJ8eHIBq1o8oLAs6xKAZRpXVU=;
	b=c9ptD/lXkA6JRlO6/4O6RBTtuHI4JJ36vpOMY3HMqzsSely2RYOzrING1kBs4SmFRVkn
	 f7brYASOah/iDePiuoM7/SlBNgv/fhGU/Z45VNkhlQLZaym9BNOddEgcZm0RQqoBEWCNl
	 EnmuMd0t15ONPVeMPvsooVh3t8jlKfMpPZpXJ8kP0CjrrgqC0HTBZmothOT4iTTARLE4r
	 wqDi4RRFWS3nwo/jU0lqo4mCUVs5f9+18dGhZrR08rkBnyh3Wh1dlr2QoM9aQQhmuxrSD
	 DekSbyyUJiT/HyFbe0nYjIWh79WnTZxUsZpLeBMpxjTpGmAOEkTv4Q6BQ/jJDwQ9uww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zWP2dO5Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FAA606A31C;
	Thu, 19 Nov 2026 00:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zWP2dO5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDE71F000C4;
	Thu, 19 Nov 2026 00:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049024;
	bh=oLwMI8UquJ3AvbLOKSqJ8eHIBq1o8oLAs6xKAZRpXVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWP2dO5ZWsAFs0b449jYvxVAyNZKLnuVJ6of2tatYQ9o/6bn6PPC/BurIx+ogStA8
	 ajVQST5nt/djcvkwEF2HEGKQMktnTG6LpIE7FO1BwgTQeSp6gUdOYPplwXeeCdyGRn
	 CZKkZ9jWkil8agYwmynlZdCmfcFpVd9x6KyrJ6C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2204/2857] .gitignore: drop Module.markers
Date: Wed, 18 Nov 2026 15:53:58 +0100
Message-ID: <20261118150320.784758296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

[ Upstream commit a7d32fa14bc74d1786a2f0513b6f0815bd4be311 ]

commit fc5377668c3d ("tracing: Remove markers") deleted the marker code
and the modpost output. Follow-up commit 8723eaeff59a ("Kbuild: clean up
marker") removed it from clean and mrproper targets. Both are from 2009,
so the file is hopefully no longer in anyone's tree, drop it from
.gitignore as well.

Fixes: 8723eaeff59a ("Kbuild: clean up marker")
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/8cbe913b9f80dc6fea73a9e3d51429db2b38905f.1790838401.git.jstancek@redhat.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .gitignore | 1 -
 1 file changed, 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index d4da8ea943327..86056b79cae8e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -65,7 +65,6 @@ modules.order
 /vmlinux-gdb.py
 /vmlinuz
 /System.map
-/Module.markers
 /modules.builtin
 /modules.builtin.modinfo
 /modules.nsdeps
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704150;
	b=LaRgBO5h5xGpO4nyFyTf1NzlsAXzskolPTa635pQ1sm9PS+j8boDZte1Z9lAqZV8VIg/
	 aXCnwVGNIowgOwKrba9SCKhLbff9bSxZZwdO9QH8Hmsa07nlNoRPZ+BuI4P9ldbnQmfr6
	 bAfU8Rk/lElUEPqlyDrDgxngkUF4F/j/1OxKhMmYKiJWHj1cJ4rtg2H0hDq3HdboY0b4f
	 JPlLt6CQEJVN2RW+Rh7arRQvhuleaReS4PeKy7uH5wuu8G0a+dsSTyP90gSdlucodoJtM
	 qny4yMRVr10CC8q+4u8ETK41+pdRyJW7ybkaPJn0lxIYrVt9rwmuAtTRBF7Z34b1pAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ipjC/eskKFH+RFv8V5XNDd4Wfbbg3Z150aNvqdHtQi8=;
	b=J+tPL4ZcX3gpRx7bS8WKYb4j28wRYJiba7nVn431zEGhD+aOEKbih0oBelA/okVdSkhz
	 /OFWANvi5/yxWf3RZClY62j3TUm6NAHw5dAOgU+eFWmJo/f6/1FkVwS8BQREaD7ajv+uk
	 oLB00zrHNMhLh1c/VfJnI8DG5cO+H021pi/1vFiUVE7wI+lFDg8zDZs4qr5ZgUyTaD37I
	 c0epzRZ0zhjr3i0FkkGw3FVfzn4J+sX5V+PeFcqYcMYjjszYnbWqtyA0WrzpQC8ULoXYb
	 xNJxO8e9VErYHhnVOZKCYwP6e1kxdla/HhUkD0JpF8Yf0LHhJAS4wxRWgD3z2Q2kWvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XB/CMelp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CCF606A321;
	Thu, 26 Nov 2026 14:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XB/CMelp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5E81F000CA;
	Thu, 26 Nov 2026 14:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704150;
	bh=ipjC/eskKFH+RFv8V5XNDd4Wfbbg3Z150aNvqdHtQi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XB/CMelpd5W5gS+toJqBb/nY2/mdW/4erEHq5rie0wh0AzblqoiyMOmoxkgoOQsGB
	 9JGTYLfHJQ8xkV3o6HNX5mzRv93FAl99HygbNIfR6gXELy9xijjxPEYPL9OSQg7gBS
	 p3Y0mp/KCVMoj3+Cp5RZc7Uf7Oy1ZHX7kBCHdwCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a079f084653164a652d1@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/265] batman-adv: avoid WARN_ON for orig_ifinfo allocation failure
Date: Thu, 26 Nov 2026 15:35:53 +0100
Message-ID: <20261126143606.695647104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit dfa953ba5366b0a80c303700dab2bbcbdc5c27e9 ]

batadv_orig_ifinfo_new() returns NULL only when its GFP_ATOMIC
allocation fails, which is a normal runtime condition and not a bug.
batadv_v_ogm_forward() already handles this the same way, simply
checking for NULL without a WARN_ON.

Do the same in batadv_iv_ogm_update_seqnos() to avoid a spurious
WARN_ON splat when the allocation fails (e.g. under fault injection).

Fixes: 7351a4822d42 ("batman-adv: split out router from orig_node")
Reported-by: syzbot+a079f084653164a652d1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a079f084653164a652d1
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 7dd42f91ac2d3..cd6e97bd57564 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1305,7 +1305,7 @@ batadv_iv_ogm_update_seqnos(const struct ethhdr *ethhdr,
 		return BATADV_NO_DUP;
 
 	orig_ifinfo = batadv_orig_ifinfo_new(orig_node, if_outgoing);
-	if (WARN_ON(!orig_ifinfo)) {
+	if (!orig_ifinfo) {
 		batadv_orig_node_put(orig_node);
 		return 0;
 	}
-- 
2.53.0




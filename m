Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23D6304BC2;
	Wed,  3 Dec 2025 15:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776213; cv=none; b=HkbiLZOlMqP/WPgSKneOTRh7kBmyLkBziNwP/Ev7wHkNnIRnQNMJk3Vz6yB7q5rOXc/HXIhskqPR0naPK0gepylMl86m5dyNd8NGoZy5FOurfErM6vWulWVFVNSSMvTyLARHkahjDH2uz0QMLkUoBgQ1ToHaB9a+qYwe3tBYyts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776213; c=relaxed/simple;
	bh=1xO0ggLUYr0EYcVOby4DEr4K5qnGqWlFW1mC0sswOKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQvW/ZWdypK8n5QozQawwZ77srg8UxKir09/u5QllbXbBu1UmxgymkHswHpQDyiW2XuskO8uE3sGe3qn6tvweKVdAyeE1AlQRFZVgaBKRHNgNo5wDlbMJ7hqS3i2H2VRzzhHXd+FOg5F0/d2y4ayoer8Gez5jvFX0nPKbvzpVYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWuVGkFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWuVGkFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E44EC4CEF5;
	Wed,  3 Dec 2025 15:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776212;
	bh=1xO0ggLUYr0EYcVOby4DEr4K5qnGqWlFW1mC0sswOKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWuVGkFnAVRpemzFIOiTj96yhujzOx908O8WYsz+Vcrko+7zAh3mkI9WYcAH59jQ1
	 7zgaUYqJIz2SI3UYdNVejJR6R3+HJq8dyQ2ME8+r2Q1Ov5LZYP+ykhxpF4saT90ND3
	 8OuQj6E+5rB9HCcxxNmUC0AILhp61fEVGohjfmTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/300] selftests: Disable dad for ipv6 in fcnal-test.sh
Date: Wed,  3 Dec 2025 16:25:19 +0100
Message-ID: <20251203152404.879885489@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 53d591730ea34f97a82f7ec6e7c987ca6e34dc21 ]

Constrained test environment; duplicate address detection is not needed
and causes races so disable it.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910025828.38900-1-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index acffe0029fdd1..806c409de124e 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -400,6 +400,8 @@ create_ns()
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.accept_dad=0
 }
 
 # create veth pair to connect namespaces and apply addresses.
-- 
2.51.0




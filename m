Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E202F8BD0;
	Fri, 21 Nov 2025 13:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732725; cv=none; b=ktSsWerWZudXY9X9YbFkISFGh8cpSsmW9bAxwAmj6PsohDWV04haNazTCeZhGdTPK0t7+jF8gB3miHsy7GffxoHtWfQozLoCn8HGV28WhLHY55CICMSP8Y/RKeC0pDrk723/l2qVdZI8CaOnNzNCBwYEup0xDTveTL4k/kgwV+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732725; c=relaxed/simple;
	bh=/Pmn7uaOcOcP72CvwZlHj+aUas0tIgOVnwh2Vucfztk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZB0/QmP2z7hvpzbpGdAIaTaEErKVCNINUz2Qn8l9Lrhg9JTIWq+gJmcS7Q0A0yxkU6AqBH0hsOboCO83kwhbjy/n73/Klolvc8LnxIInkA+0m8MiFPEZBGDU59QYrVQfqVs0Ep1Nm+oaPEGnUmMyPOE+ICQsssFfOFV/Jpg3JMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRtWWd8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRtWWd8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5C6C4CEF1;
	Fri, 21 Nov 2025 13:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732724;
	bh=/Pmn7uaOcOcP72CvwZlHj+aUas0tIgOVnwh2Vucfztk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRtWWd8WOIC0JM51LNRHG4b8PnR+f896C+AvBjGciE0ngFOKxuHqzO3F41+g6MMdu
	 ZpZzB2xihAbEN3gCH65pQ/eA1s8KjQEcRFM7mJYF0IcUWz8KKEnpxclZ5FY8j35vwV
	 qBPAkXinhA8Abh6LvUZ3HFaKDRF3sug6fl0rxI5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/529] selftests: Replace sleep with slowwait
Date: Fri, 21 Nov 2025 14:08:41 +0100
Message-ID: <20251121130238.912850984@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 2f186dd5585c3afb415df80e52f71af16c9d3655 ]

Replace the sleep in kill_procs with slowwait.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910025828.38900-2-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index b4d7b1994091b..5d8f50cd38b7e 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -194,7 +194,7 @@ show_hint()
 kill_procs()
 {
 	killall nettest ping ping6 >/dev/null 2>&1
-	sleep 1
+	slowwait 2 sh -c 'test -z "$(pgrep '"'^(nettest|ping|ping6)$'"')"'
 }
 
 do_run_cmd()
-- 
2.51.0




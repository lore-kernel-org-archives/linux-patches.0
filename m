Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF854052DC;
	Thu, 30 Jul 2026 15:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424037; cv=none; b=UYlRsMW/B15Zrud7YrIYqwDQXXW7vIHGn9Q8ZIn3UpnpOn6cy7OtzSk2MFoHcaXiB+EfTnFA1bZ1ReAayuhkL5cYNElq1YdBjtRUlpgGpTsgwKwFEEiF7Ec+x5Te5pjQ+uj3lDpoCxPhVGR6mLgJ0hoE+Kwpz7TMeUbUQ1oQFmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424037; c=relaxed/simple;
	bh=uIf17GP/TwWhcZiscQ92zkeQbTx5pUYq14SHWMKMwwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aG3qzq/J3pM9VzKvVNZ53r7x7Sin0RhrK/+5ArKbHUM/xMerFjVVxRmPip+q25lqKVWbhguJsCm8kIgJMnGlgm2sS26m+pEpNr8D8UNdrX0JxQlInG7wfI+vkOQixtEpSo6lhRllG7PZl/pNbmvbwWfwAQowRMabWWDeX/ByAjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnvGwNoW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnvGwNoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B141F000E9;
	Thu, 30 Jul 2026 15:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424035;
	bh=3aC4Jrxqpa0FRzLCNyHdVaJu/qe3ab2UdjIIW9Sxa0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DnvGwNoWW+FDgF52mXnu4xdRmB3wFyM42c7ozGMaFnur/d1vQpAUIMQ0QpcpS43Ry
	 sWMgD/bM7dzuvaMThNXzkJa6aa7oXW4vJqeJcqf9TXqI+nG4r/km5+j+SvJoSibk7q
	 Ja/9Y/PpLv2g5XpjKLYXDzGrHAwFKMVpNK1tYAzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 252/675] selftests: drv-net: increase timeout
Date: Thu, 30 Jul 2026 16:09:42 +0200
Message-ID: <20260730141450.493123756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 3529d75d67411497341cd804a045185d6035dff2 ]

The default timeout is 45 seconds, that's too low for the xdp.py test.

Indeed, this test can take up to 3 minutes with some debug kernel config
on NIPA. Set a timeout to 6 minutes, just to be on the safe side.

Note that the Fixes tag here points to the introduction of the xdp.py
test because I don't know when this test started to take more than 45
seconds. That's OK because a timeout of 6 minutes is not exaggerated.

Fixes: 1cbcb1b28b26 ("selftests: drv-net: Test XDP_PASS/DROP support")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260710-net-sft-fix-containers-v1-5-a2915c294ef5@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/settings | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/drivers/net/settings

diff --git a/tools/testing/selftests/drivers/net/settings b/tools/testing/selftests/drivers/net/settings
new file mode 100644
index 00000000000000..eef533824a3c19
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/settings
@@ -0,0 +1 @@
+timeout=360
-- 
2.53.0




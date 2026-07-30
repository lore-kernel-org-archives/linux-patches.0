Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961AC43E487;
	Thu, 30 Jul 2026 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421968; cv=none; b=nIN13szPEOJKbnhQq9CLx/30coTVacUybiZ2IdA21x7WfXakjHj9q3tn+pH71O4A+pqv5qnT8TIDffzMBKZB4oeJlDiUvJ2QdlLCkX115boz+gu9XeCilg0uXKPeDPVTmMMvgB6qK4Sg5jWOhiEMee9ocRwXAhpSBdmyOWTwQ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421968; c=relaxed/simple;
	bh=w5qiH2OGBfexglhPEgNYokUt8OyobnXO67LngA4DDVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzZsVHUxDxZBRZ+mJWcgZT0zsMnly8B1b/gO1YsprOo1MsJ1V9DzKNiTMYdYivJeKrKz14291C/MdaAg1bP9jkdx7kwJHkh5okQ8rY9FiXHgoRtd5na/9Uv+hLEyqF+xQL174NMzA4InD7+7ZnAHQIBVXakaeLI/mfPApFJo22E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGo7yXiy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGo7yXiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBA11F000E9;
	Thu, 30 Jul 2026 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421967;
	bh=D2VB18oSSB9nwf8UpKX2xJH8SIMSVxbMfTB/5Gyhpsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGo7yXiyZ2q0wxpSRmU9jCtZaLdRrJOxhRC0xLZFe3CqyCAHDOyKbLTgmaKL2602K
	 rxh3vTCdmqi3TCA1hlXKA0NCwknr2dYgedlEUjmhfSWWN4E2IgwmRfhRTKd5/zmear
	 qw25zi2u6s4uLuptpGqAqYeIWmVtffm2bdXW0LgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 281/744] selftests: drv-net: increase timeout
Date: Thu, 30 Jul 2026 16:09:14 +0200
Message-ID: <20260730141450.260303251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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




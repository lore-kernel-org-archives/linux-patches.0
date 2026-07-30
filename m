Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325CB417D7E;
	Thu, 30 Jul 2026 15:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424034; cv=none; b=stX+jiWa0AN1YDgrLHKQ1fP5btgyBRbBPzJ6QnFK/pw4MIBdOPxDODU//JRghwr7q4F72Po6FMxnyfeUPMKIlOqQ1madBhoYJVZw8/Am35EBeq3awPet8a1/sAsu1T8n0AvUmFKeVbRBp7JFqqsMGPcjAyNKUhUpqXPSf8XN9C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424034; c=relaxed/simple;
	bh=9HpBIvNATxdGCyDPXoVVoC34+KhhCyxRmRr6vRnCWZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/z57JTIgpQgGWO8lJmV1uGGdK5fli4tHdERJpYj9osLg/bENg//E71/xa3xDbsgKOTEB/nZUomZQxlSVWS5TS3TNaEaOYV9cUjbptmimDepUSj+1pGXcogEk9/HPO+kvt95xiD3zu6bcvM7V4S+ZSk4In36Uh7EvBtxg9R5Els=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbsQcc2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbsQcc2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6BA1F000E9;
	Thu, 30 Jul 2026 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424033;
	bh=jjtkpvPAHrl7ZvHb/8w+jxrtTCF7icoNayE3FaDChtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbsQcc2CEwXXBBu9GXAFFBnHQipsZNej3jDg4WnJ0vbVg3ZBEvNfuXO6QIDQNtBJv
	 6/bRtP2c11ZTsp0lOUy7TKyryIyKoQ2qsEkXpPhSd2l44HvzjZ7PuX41KUKnukFcZS
	 Tc/t0NBRUqIHYF9nk1wgDzHcMq7lXDFJ6UFUQYi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Antonio Quartulli <antonio@openvpn.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 251/675] selftests: ovpn: increase timeout
Date: Thu, 30 Jul 2026 16:09:41 +0200
Message-ID: <20260730141450.472225138@linuxfoundation.org>
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

[ Upstream commit 61ac7049aaa86ae044e8a5b94d852218163d5bf8 ]

The default timeout is 45 seconds, that's too low for a few ovpn tests.

Indeed, these tests can take up to 50 seconds with some debug kernel
config on NIPA. Set a timeout to 90 seconds, just to be on the safe
side.

Note that the Fixes tag here points to the introduction of the ovpn
tests because I don't know when they started to take more than 45
seconds. That's OK because a timeout of 1.5 minutes is not exaggerated.

Fixes: 959bc330a439 ("testing/selftests: add test tool and scripts for ovpn module")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Acked-by: Antonio Quartulli <antonio@openvpn.net>
Link: https://patch.msgid.link/20260710-net-sft-fix-containers-v1-4-a2915c294ef5@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/ovpn/settings | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/net/ovpn/settings

diff --git a/tools/testing/selftests/net/ovpn/settings b/tools/testing/selftests/net/ovpn/settings
new file mode 100644
index 00000000000000..ba4d85f74cd6b9
--- /dev/null
+++ b/tools/testing/selftests/net/ovpn/settings
@@ -0,0 +1 @@
+timeout=90
-- 
2.53.0




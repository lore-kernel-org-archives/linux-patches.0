Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041529;
	b=vVoVCT2v6c0Ug0ZTXp2D5JId6eVcyQEjlSndOxrQALG1NzswjG4jyYzpT2Qdfs1E+vU8
	 Goq5otLSy9VshJbjP46pbZFPN5KO+EuvalP+6Dd5cPzQQ0TYE86o+rLEM7Z/SgMml7SVl
	 j5VkY7WjbnUpLDvoCEP7DImdm6PmrhUMLoar51zD0PAwaxEPH49330ji1I6e1/QnXqP8+
	 BWLugg+xc0t2vLa1VebodkvDaHXxptQdw9ifD4i4ddVhd59jIJH+j5Bdo4YTN4YRz5pXr
	 OXbY7KFiqq2CeAnprqPxvvBNluOwdfLWPBYVFI/eVRvXLFSY2VtXanlzWQ+VM0/o4/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7s6K/RtE3jNkOwV/gtnXDb21FiKwdZlvNSk05fq8fDs=;
	b=JCkd/xNDRBdsP0422QThvDLd2d0SXQMMaoMkeMZ+dU832pLSpl6nySQP0CKFi/DUYqdC
	 pOuCv+bHdW5zjxpUTZAtAFyhbdWXQdzySex9JoyRWenm0YLJeHDlWuXWXL1m+C+GxnhbD
	 EXHldHUDtZNalreRUGlM7Y0p2N/AM1WRdjU75Pj6iLg59dU8wuGeSdejCoeFSnFJfjgfZ
	 wsh+6TA3qeoBPBZXxiwboW6YTDAIPp4gc/1KzPCd+0GlrGh9tqrpa+SXZrcI4N7T9Nk7S
	 yk9yAZDjz6nhJ3LnYuhzdFDolVN/Ax54YIaiEUFB5wTFU78rbnFF93HZai5+G+8rs7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h8tMYoQ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07C9606A32F;
	Wed, 18 Nov 2026 22:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8tMYoQ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B131F000C4;
	Wed, 18 Nov 2026 22:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041529;
	bh=7s6K/RtE3jNkOwV/gtnXDb21FiKwdZlvNSk05fq8fDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8tMYoQ/R6R6unBQZaUiIylSPGf20bFucUniSsOm6DHbgkSoJ5kl/+cJda16/hVGc
	 jKGSXvddAcVosilSRJUu8ovAoaeLBzOO9JFESl5dzvMsCg0Bm1g4WyAKeeogu1x47V
	 Y0TKjBsNej2D+TlRKE9teJot04zAvLy2RUYnAjtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2844/3318] tools/thermal/tmon: Fix string truncation warning in optarg copy
Date: Wed, 18 Nov 2026 15:57:46 +0100
Message-ID: <20261118150445.930996562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 602da762f7a7c494a95cb204ac005965b214e556 ]

GCC warns about possible string truncation with -Wstringop-truncation:

  tmon.c: In function ‘main’:
  tmon.c:233:25: warning: ‘__builtin_strncpy’ specified bound 20 equals
destination size [-Wstringop-truncation]
    233 |                         strncpy(ctrl_cdev, optarg,
	CDEV_NAME_SIZE);
        |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Replace strncpy() with snprintf() to guarantee NUL-termination and
silence the compiler warning.

Fixes: 94f69966faf8 ("tools/thermal: Introduce tmon, a tool for thermal subsystem")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260929201951.408456-1-florian.fainelli@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/thermal/tmon/tmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
index 7eb3216a27f45..0c8deee4652e2 100644
--- a/tools/thermal/tmon/tmon.c
+++ b/tools/thermal/tmon/tmon.c
@@ -230,7 +230,7 @@ int main(int argc, char **argv)
 		switch (c) {
 		case 'c':
 			no_control = 0;
-			strncpy(ctrl_cdev, optarg, CDEV_NAME_SIZE);
+			snprintf(ctrl_cdev, sizeof(ctrl_cdev), "%s", optarg);
 			break;
 		case 'd':
 			start_daemon_mode();
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043851;
	b=F7sc0GJDNRMtz1ZNzgfrIhAOzuGxUR6mrKWoJLOHqsfDLIGZXXpHMVnY79jbg6tDwEM3
	 vI7qWUrLPKAxf1flhLkdbqiUU6TaP1/I9n0Dw4W2i0SqqYIrv3+vSO64Dy841XEbCTdJM
	 aZV88uNrAZ7Ccf1vfS4aM1Al2o9doFkmU3oRF0LRLU8BHgDUff5D+e2nZiDh6spVz/iRR
	 /XlS5IJF3oieTdE4g8rpdJX1VtoXxRtGUs+c8t5kKKY1hbrDWeDOM8NZut3zE5wWa99cO
	 1+KJ4J0eJrRI/oOD99gdiChR648bw0VpMfxl9kMVcVdfxCywmJhTK1fAvgmH2d53Ysw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Apx9RynkHMFlD3BhrcOpt2T7bPW8k5p45DCsXLHNJjQ=;
	b=g9eWAlVC1kD9tYbbAvN4PACBTjxR6FmQ3InMxZGsjcSOrarKEkP18LSi8jMgDWzVgeD9
	 W2YsZijOaJ+LhIvf0Zx+vBSvXnQ+VeFjUZXVy1iZ/koW2Y5RsEuAWMdH4CfHCU1Wwutwx
	 U9K952YiY3EnVpr0vNJXLbokmKfEijdeERep9tRViE60GA0T7085DPt5YoK7d/UfHhjcx
	 MlJv8MMfWAqhw5co7KXQjDW/rr2m4Aq5xXczrIgDPHo0v1VZgyQaZNd+ZrjeKItdDi4bW
	 +GqdDBUhKTdkpA5F4+v65tOV1Jk12N4lOQwQl/8LUt+07ea1J+VTpiIvtDAoV7nTpug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=maxCGIiW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05764606A320;
	Wed, 18 Nov 2026 23:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=maxCGIiW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE251F000C7;
	Wed, 18 Nov 2026 23:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043850;
	bh=Apx9RynkHMFlD3BhrcOpt2T7bPW8k5p45DCsXLHNJjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=maxCGIiWikbx7B+s6TnCXbylZXvnDYlq/RHTfdBdXeygJkyR3U2I0ebnwHBOaz94I
	 vRDzPff3AfnNI11oDOJBTeC63k3GconMuNaEQGnN/LhM5kln0j+UDVh/Cn7xnGHiPp
	 XNtDfhfgflxgJ0Cf2QXvbNiMq2gbiD4NHXm/loTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0357/2857] ALSA: hda/ext: preserve PPLCCTL bits when clearing reset
Date: Wed, 18 Nov 2026 15:23:11 +0100
Message-ID: <20261118150214.295668294@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 36aa66de481d29edd63cbad9b5c4dc18c340fdf6 ]

snd_hdac_ext_stream_reset() polls PPLCCTL for STRST by masking the
register value with AZX_PPLCCTL_STRST:

	val = readl(...) & AZX_PPLCCTL_STRST;

The same masked value is then used when clearing STRST. Since val
contains no bits other than STRST, clearing STRST from it always
produces zero. The subsequent writel() therefore writes zero to the
entire PPLCCTL register instead of clearing only the reset bit.

PPLCCTL contains other stream control fields, including the stream tag
in AZX_PPLCCTL_STRM_MASK. Those fields must not be modified as a side
effect of clearing stream reset.

Use snd_hdac_updatel() to clear STRST, matching the existing set-reset
path and preserving all unrelated PPLCCTL bits.

Fixes: df203a4e46f4 ("ALSA: hdac_ext: add extended stream capabilities")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/43BB7930B0F07C09+20260813065524.1955696-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/ext/hdac_ext_stream.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/hda/ext/hdac_ext_stream.c b/sound/hda/ext/hdac_ext_stream.c
index 70f3ad71aaf0d..4681d25a38448 100644
--- a/sound/hda/ext/hdac_ext_stream.c
+++ b/sound/hda/ext/hdac_ext_stream.c
@@ -182,8 +182,8 @@ void snd_hdac_ext_link_stream_reset(struct hdac_ext_stream *hext_stream)
 			break;
 		udelay(3);
 	} while (--timeout);
-	val &= ~AZX_PPLCCTL_STRST;
-	writel(val, hext_stream->pplc_addr + AZX_REG_PPLCCTL);
+	snd_hdac_updatel(hext_stream->pplc_addr, AZX_REG_PPLCCTL,
+			 AZX_PPLCCTL_STRST, 0);
 	udelay(3);
 
 	timeout = 50;
-- 
2.53.0




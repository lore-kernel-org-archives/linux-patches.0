Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016837;
	b=EMxP+eEU/Pw325xxgyvIKtKLucL7J/HPnUzcql1Wff2poi05nxKzGHaa6ERC9E5x1A0Y
	 6rbudNTSrWGhfC50DDJX0P2KuXt24VRQ01moaq75Ds85HYTZHiiXdjiUUp4S+dZA9HwWx
	 LZnOPH/xJVQBTCGyDC3i8abakJ5lmuIT72c9fZ6TZnMnMFaqBNgvBQY0swXhKb1jveYo2
	 lb+BSXi9HhH+EbGOYlvE4QffPGchWP5HibJgcaM9w/oWewRhDnE+uYOGtBGImwOEvEu7o
	 5zgcj/ovHOhPMT6bckt+mAhm5+mrqVDF0/8FoxGQb6BPadQMu2pv3RoyB43G0rsCoDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SFEIR1kYtH+sR3AZV/k6FlFwU/vCtiKfeMblhazeAvw=;
	b=0fHP0bGY+pGt6yH3kNdsdvGxFE4F5PjRLqe7UNVJ12kBscPYIPGQuOmYMunOGoULyMZb
	 vCKkZjtPSLIeNj8/ZYcKJGkKP5G6ZdNIPYlEgqtsZjWNsb4Ezlc+M7AkMz+jUST62CgKT
	 17shbbre/dEF9so2CoriGruxboKNJmaUOaBC7MM1RUV2J/xDH/snDVmTd7A+MmsYlcxlW
	 lzKXIkZfH3ds6y4rYQXEWPJbuGupM4JZJNhjejmCyQvJEMvPJohz0e9Xf85IG1wEogKen
	 xU3dL82939lmGuDcpFsmCSfAcInFHU9bb62a/TKPUsYjr1wY6d7y2TeeDGgQgY3drUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0mV7mvg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B8B606A320;
	Wed, 18 Nov 2026 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0mV7mvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D831F000C4;
	Wed, 18 Nov 2026 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016836;
	bh=SFEIR1kYtH+sR3AZV/k6FlFwU/vCtiKfeMblhazeAvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0mV7mvgvJLNengoh3LsYlNXNrzu2FgJh3gJpz7I2Uiq0DEmBcKITjvZlLpAfwOKB
	 0gQnRbKbeg60Mh6pbmwFJvNLJahtdTWjnwyvfdlQl+cUq8O3NmOjZT6cMIhmwlOzuw
	 8xRdBN/QpX8WWhijBqFgSX/9tqxntVBG3Pinaj0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mark Brown <broonie@kerenl.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0670/2651] ASoC: amd: acp-es8336: Switch to use acpi_bus_get_primary_device()
Date: Wed, 18 Nov 2026 15:31:50 +0100
Message-ID: <20261118150311.991248524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 6f50ab7ab1f93e874fa75d18bf98bbca4ce0204f ]

Replace acpi_get_first_physical_node() that is slated for removal
with acpi_bus_get_primary_device() that takes a reference to the
device it is about to return.

This addresses a potential use-after-free that may occur if the
device returned by acpi_get_first_physical_node() is removed right
after dropping its ACPI companion's physical_node_lock in that
function.

It also fixes a device reference counting issue that may lead to
a premature device release if gpiod_get_optional() fails in
st_es8336_late_probe().

Fixes: 02527c3f2300 ("ASoC: amd: add Machine driver for Jadeite platform")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Mark Brown <broonie@kerenl.org>
Link: https://patch.msgid.link/2063881.yKVeVyVuyW@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-es8336.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp-es8336.c b/sound/soc/amd/acp-es8336.c
index 9f3f11256788e..34e953d1a3a76 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -198,7 +198,7 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 	if (!adev)
 		return -ENODEV;
 
-	codec_dev = acpi_get_first_physical_node(adev);
+	codec_dev = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!codec_dev) {
 		dev_err(card->dev, "can not find codec dev\n");
-- 
2.53.0




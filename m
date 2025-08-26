Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5471CD1F;
	Tue, 26 Aug 2025 14:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217970; cv=none; b=HEuZpLEFqiLiHSmldEBM0m3PRG6U83Zo/vtWc7UoS6cc+Oxrq3lUSvej/V33ufUzOvWc/IgbRRPWbNnR6kMry4OtSfoN2NnDHEk8EEMiTfidWPv0q3Q1WgencHlgVaPGMEXU/8HkgpYpbGKEGue+i4MO9OBuMa+2bI/ob6mnMIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217970; c=relaxed/simple;
	bh=J78/wT+HNDwF6bdM1PbrMAR/ekQzWU2C3ls9eb7yEXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV8L+0ejX0OBrFhdWrQ+4Cc2G54PhMHdnJx/qX0I4cnmWFzl9MGVYlA7/UahDGZ3rx81GfUG7lFo5EfeV8i4/g3IFP0J+1BQsyTyFNAQQVrCULilQ9FEGaZ/W/6ySk6h92+trzcaJbS8AbDXTz9hp0NmJd78seW9wQkL1BpAwC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjMyA7qD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjMyA7qD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D935C116D0;
	Tue, 26 Aug 2025 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217970;
	bh=J78/wT+HNDwF6bdM1PbrMAR/ekQzWU2C3ls9eb7yEXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjMyA7qDicliSdI1Mt0wxbjPBFzZMewoSwmizXa7g9HuULn5nvv9iRE+bt5q9UJmS
	 Xx6kikL8nnrQ5SdvbCf63PFCCVs7/8yI6kE0bsdh+KwEY4XXK06AAmyR9u+w29YgiG
	 1wk4UA//dtc+WNk+UlVeuyuY9hM8jlwHoP4OtvA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 345/523] thunderbolt: Fix copy+paste error in match_service_id()
Date: Tue, 26 Aug 2025 13:09:15 +0200
Message-ID: <20250826110932.978316261@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Biggers <ebiggers@kernel.org>

commit 5cc1f66cb23cccc704e3def27ad31ed479e934a5 upstream.

The second instance of TBSVC_MATCH_PROTOCOL_VERSION seems to have been
intended to be TBSVC_MATCH_PROTOCOL_REVISION.

Fixes: d1ff70241a27 ("thunderbolt: Add support for XDomain discovery protocol")
Cc: stable <stable@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20250721050136.30004-1-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -38,7 +38,7 @@ static bool match_service_id(const struc
 			return false;
 	}
 
-	if (id->match_flags & TBSVC_MATCH_PROTOCOL_VERSION) {
+	if (id->match_flags & TBSVC_MATCH_PROTOCOL_REVISION) {
 		if (id->protocol_revision != svc->prtcrevs)
 			return false;
 	}



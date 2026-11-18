Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016670;
	b=opB1QvCK666SN1hjHy20YE/lgSkFd4A7s+q/W8jCce4HIYiK23gOQwWfgLiojAclfVLC
	 f6ybuXUqu5QsDYeu+G55IAioXbsN9wsKx6LtCWJhOJbDU/kn7j4S6YW0jfBpJ+7swwlTe
	 PD/U9gXnARNG3ncgZbh96xqnardBnY/vmCjfQP58yRlz+PK6eGYLfMHdY88i0zVKiwm77
	 o8HxhrnxUyPL2mWBzgWiotRKjA1R+aJ0IHoe9FlpXtBANYMSEZhcLgqjqlGX0QTR7Q5k1
	 gyFilCUV9AOM4BPqexvYp+gKaQKn3ZlWnumwpKq9eXZvjJz/xyPPwf3yWYSMkijKHRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5i4RVQjipDTGtVxS/VwXSDnO3Ld4+QHOVn+T/f+FvIk=;
	b=PiOonCGW7X0VRVlbyL1y6t/I/Eeby4cZs2qkVhQP8shvPggqTlrIzvvq3Q57Z6iUVnCP
	 T8T1EYurqpXhYjcAmddBo9iZRaZ+3uvfKdiMoQ1AIWhpy5xYU4qvkkmXhWMK1neT+pqiW
	 aEhHVroSbaRh8QNwXE3japDLk/fN0vFxtIfG93LzVr7b5hFTMnnEdSTMXDIZw33fcnRYz
	 +cts28qrmOpUefs4/lu8w63HNqVZJE1p5F0LLxqK/Yqgc5TZ4+wnyWBTt7Ak1crjbPw+B
	 aEJzyAJJkBhekMx85Q4Q/U8chnMF+uwgpIIJybk+sDhYNQBywEd/Ys2uCpZngcR3RjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wbxCfKUX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25C0606A31C;
	Wed, 18 Nov 2026 15:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wbxCfKUX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D18B1F000C4;
	Wed, 18 Nov 2026 15:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016670;
	bh=5i4RVQjipDTGtVxS/VwXSDnO3Ld4+QHOVn+T/f+FvIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wbxCfKUXjAuWvEJfMsApXBE3LvZ81SZLWg4OS3L+RzCDzZhFBHS7+bLy1c1qFk3np
	 oh/wWyVu07EFM0Y+zExDyiIQ8p/sbZ6Rc4bwYxWKbWOH3SQ8VzH823CwaEXxp4ijhT
	 aIgnEu9rxEt602I6nP6MiArxhnndhWOh3yU+cWvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0604/2651] ASoC: SDCA: Improve scanning the SWFT during FDL
Date: Wed, 18 Nov 2026 15:30:44 +0100
Message-ID: <20261118150309.463503412@linuxfoundation.org>
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

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 4454102d6565afedfcde64b222595f067a5b7e93 ]

Walking through SWFT is now improved to verify if it is not reading
past the end of the table.

Introduce file length checks that are done for SWFs from disk to files
from SWFT too.

Fixes: 71f7990a34cd ("ASoC: SDCA: Add FDL library for XU entities")
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260917103400.2032913-1-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_fdl.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sdca/sdca_fdl.c b/sound/soc/sdca/sdca_fdl.c
index 150e36ed24bcc..e08a553e0eab0 100644
--- a/sound/soc/sdca/sdca_fdl.c
+++ b/sound/soc/sdca/sdca_fdl.c
@@ -199,7 +199,6 @@ static int fdl_load_file(struct sdca_interrupt *interrupt,
 	struct sdca_fdl_file *fdl_file;
 	char *disk_filename;
 	int ret;
-	int i;
 
 	if (!set) {
 		dev_err(dev, "request to load SWF with no set\n");
@@ -209,9 +208,18 @@ static int fdl_load_file(struct sdca_interrupt *interrupt,
 	fdl_file = &set->files[file_index];
 
 	if (fdl_data->swft) {
-		tmp = fdl_data->swft->files;
-		for (i = 0; i < fdl_data->swft->header.length; i += tmp->file_length,
-		     tmp = ACPI_ADD_PTR(struct acpi_sw_file, tmp, tmp->file_length)) {
+		struct acpi_sw_file *table_end, *next;
+
+		table_end = ACPI_ADD_PTR(struct acpi_sw_file, fdl_data->swft,
+					 fdl_data->swft->header.length);
+		for (tmp = fdl_data->swft->files; tmp + 1 <= table_end; tmp = next) {
+			next = ACPI_ADD_PTR(struct acpi_sw_file, tmp, tmp->file_length);
+
+			if (tmp->file_length < sizeof(*tmp) || next > table_end) {
+				dev_err(dev, "bad file length in SWFT: %u\n", tmp->file_length);
+				break;
+			}
+
 			if (tmp->vendor_id == fdl_file->vendor_id &&
 			    tmp->file_id == fdl_file->file_id) {
 				dev_dbg(dev, "located SWF in ACPI: %x-%x-%x\n",
-- 
2.53.0




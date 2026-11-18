Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018502;
	b=fBS3hjRQhWEyMsc2XdwgG59Wvi7o4WiZjFYU500B+9Ekg4h4XDVdUQcwMi3gCSkXiiGJ
	 OED3z9uDtW4QIqNTqj/5BcydWEzoxALPJ7dlilW9C06y7RYkI5SR8w3JJ+mMn737Jma+4
	 +vz9TCe4o0L6HiIJ9upkJCLg376Rs4PEAdq8lfpEGwc4jytS5/3pb/1dqK829pygwW3dy
	 S0TQMo6XXva7dXz5BXT8pRm+oQDM9mR4oX3XoPJ+EaXXLi9M2if4bYX40Kag/hAw+GswS
	 oQ5M68+cbXV7FEkEWqEkEERnIZjwoBOhZLHGxf+171ATPkT3AR4Ku6qcJxHLu+PbnWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SkrM6I4gu0eVkCOlOnZWLU7mgKoiPbu2wXtAFgnm2a8=;
	b=ssNvOIkztIwr5nvkI52HQF1CENY5Rwbl8uVCfqIWHoA4V0gxCURDOxFfBdrI7Mln7vUP
	 x3YkUTwO75QWdiAunCUHVQBX8YVmKwCl/xqzDOXsVyFzi1yoMs9rCt6gKAYlVlhyEB6m8
	 4tLa2bdy032fyoLuBVaGejdCBVn3PZL1dYTnRLRF7nDEdbxqelajB90N7w16NjswEKle9
	 KM17ifzCN+8nTK7wsqWkj/zsXJfzbKZGuBdooY0+j0IvU+vvq3PH3RToOjUi5Dam5j6od
	 3bQbiffkYeV9tZzMNeE0fPNxNAM0JHXUqyOheLFlpGCKqhAV2wXJfoplVdd8UntPKqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6DcVh48;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EB8606A31C;
	Wed, 18 Nov 2026 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6DcVh48
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E9A1F000C4;
	Wed, 18 Nov 2026 16:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018502;
	bh=SkrM6I4gu0eVkCOlOnZWLU7mgKoiPbu2wXtAFgnm2a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6DcVh48wIT2xwEbOC1sF0nPl1fK/9AIDCW/KVBNh0npuYcU1vpEIQZ+LmBYUMHIj
	 pWl1JCJsIyCYZsIcSpRIEpRrANN69RJF4rgqvkM27WODngQJL2x6YhGbZhQQklE788
	 AijvU70TAYQ54rkNrcHiG9M+72Y8pnA5NBt+aM8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1223/2651] scsi: core: Prepare for using combined sense codes
Date: Wed, 18 Nov 2026 15:41:03 +0100
Message-ID: <20261118150332.033716005@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit ec5562d3ea803ec45831477129c626b2a22d2e2c ]

In preparation for handling sense codes and their qualifers as a single
16-bit sense code field, with the values defined as macros in
include/scsi/scsi_sense.h, modify the definition of the structures
scsi_failure and scsi_sense_hdr to introduce a 16-bit sense_code field as a
union with the existing 8-bit asc and ascq fields.

This temporary modification allows accessing either the asc and ascq fields
individually, or their combination as the 16-bit sense_code field.

The helper functions scsi_sense_asc(), scsi_sense_ascq() are defined to
allow accessing the 8-bit ASC and ASCQ values from the sense_code filed of
struct scsi_sense_hdr. The helper functions scsi_failure_asc() and
scsi_failure_ascq() provide the same for the sense code field of struct
scsi_failure.

The helper functions scsi_set_sense_buffer() and scsi_set_sense() are also
added to wrap calls to scsi_build_sense_buffer() and scsi_build_sense()
using a 16-bit sense code argument instead of the 8-bit ASC and ASCQ
arguments.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260908090308.1085097-6-dlemoal@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Stable-dep-of: 63cb3900be26 ("scsi: scsi_debug: Enforce physical block alignment of zoned writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/scsi_cmnd.h   |  7 +++++++
 include/scsi/scsi_common.h | 31 +++++++++++++++++++++++++++++--
 include/scsi/scsi_device.h | 25 +++++++++++++++++++++++--
 3 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db5..bf6d69f0249f8 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -394,6 +394,13 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
 			     u8 key, u8 asc, u8 ascq);
 
+static inline void scsi_set_sense(struct scsi_cmnd *scmd, int desc,
+				  u8 key, u16 code)
+{
+	scsi_build_sense(scmd, desc, key, scsi_sense_code_asc(code),
+			 scsi_sense_code_ascq(code));
+}
+
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
 				   blk_mq_req_flags_t flags);
 
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 00c8a16d3cd24..6fb2c290ba33d 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -71,8 +71,18 @@ extern u64 scsilun_to_int(struct scsi_lun *);
 struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
 	u8 response_code;	/* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
 	u8 sense_key;
-	u8 asc;
-	u8 ascq;
+	union {
+		struct {
+#if defined(__BIG_ENDIAN)
+			u8 asc;
+			u8 ascq;
+#elif defined(__LITTLE_ENDIAN)
+			u8 ascq;
+			u8 asc;
+#endif
+		};
+		u16 sense_code;
+	};
 	u8 byte4;
 	u8 byte5;
 	u8 byte6;
@@ -87,10 +97,27 @@ static inline bool scsi_sense_valid(const struct scsi_sense_hdr *sshdr)
 	return (sshdr->response_code & 0x70) == 0x70;
 }
 
+static inline u8 scsi_sense_asc(const struct scsi_sense_hdr *sshdr)
+{
+	return scsi_sense_code_asc(sshdr->sense_code);
+}
+
+static inline u8 scsi_sense_ascq(const struct scsi_sense_hdr *sshdr)
+{
+	return scsi_sense_code_ascq(sshdr->sense_code);
+}
+
 extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 				 struct scsi_sense_hdr *sshdr);
 
 extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
+
+static inline void scsi_set_sense_buffer(int desc, u8 *buf, u8 key, u16 code)
+{
+	scsi_build_sense_buffer(desc, buf, key, scsi_sense_code_asc(code),
+				scsi_sense_code_ascq(code));
+}
+
 int scsi_set_sense_information(u8 *buf, int buf_len, u64 info);
 int scsi_set_sense_field_pointer(u8 *buf, int buf_len, u16 fp, u8 bp, bool cd);
 extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e321471e8ca22..11910142ac505 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -518,6 +518,7 @@ extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
  * to match any sense key, ASC, and ASCQ value.
  */
 #define SCMD_FAILURE_SENSE_KEY_ANY	0xff
+#define SCMD_FAILURE_SENSE_CODE_ANY	0xffff
 #define SCMD_FAILURE_ASC_ANY		0xff
 #define SCMD_FAILURE_ASCQ_ANY		0xff
 /* Always retry a matching failure. */
@@ -526,8 +527,18 @@ extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
 struct scsi_failure {
 	int result;
 	u8 sense_key;
-	u8 asc;
-	u8 ascq;
+	union {
+		struct {
+#if defined(__BIG_ENDIAN)
+			u8 asc;
+			u8 ascq;
+#elif defined(__LITTLE_ENDIAN)
+			u8 ascq;
+			u8 asc;
+#endif
+		};
+		u16 sense_code;
+	};
 	/*
 	 * Number of times scsi_execute_cmd will retry the failure. It does
 	 * not count for the total_allowed.
@@ -537,6 +548,16 @@ struct scsi_failure {
 	s8 retries;
 };
 
+static inline u8 scsi_failure_asc(const struct scsi_failure *failure)
+{
+	return scsi_sense_code_asc(failure->sense_code);
+}
+
+static inline u8 scsi_failure_ascq(const struct scsi_failure *failure)
+{
+	return scsi_sense_code_ascq(failure->sense_code);
+}
+
 struct scsi_failures {
 	/*
 	 * If a scsi_failure does not have a retry limit setup this limit will
-- 
2.53.0



